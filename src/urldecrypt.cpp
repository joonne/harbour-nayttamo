/*
  Copyright (C) 2018 Matti Lehtimäki <matti.lehtimaki@gmail.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "urldecrypt.h"
#include <QByteArray>
#include <QDebug>
#include <openssl/evp.h>

QString UrlDecrypt::decryptUrl(const QString &url)
{
    QByteArray baseDecoded = QByteArray::fromBase64(url.toStdString().c_str());
    QByteArray qiv = baseDecoded.left(16);
    QByteArray qmsg = baseDecoded.mid(16);
    QByteArray qkey = QString("%1").arg(DECRYPT_KEY, 16, 16, QChar('0')).toLatin1();

    const char *key, *iv, *data;
    int key_length, iv_length, data_length;
    key = reinterpret_cast<const char*>(qkey.data());
    key_length = qkey.length();
    iv = reinterpret_cast<const char*>(qiv.data());
    iv_length = qiv.length();
    data = reinterpret_cast<const char*>(qmsg.data());
    data_length = qmsg.length();

    const EVP_CIPHER *cipher;
    int cipher_key_length, cipher_iv_length;
    cipher = EVP_aes_128_cbc();
    cipher_key_length = EVP_CIPHER_key_length(cipher);
    cipher_iv_length = EVP_CIPHER_iv_length(cipher);

    if (key_length != cipher_key_length) {
      qWarning() << "Error: key length must be " << cipher_key_length;
      return QString();
    }
    if (iv_length != cipher_iv_length) {
      qWarning() << "Error: iv length must be " << cipher_iv_length;
      return QString();
    }

    EVP_CIPHER_CTX ctx;

    EVP_CIPHER_CTX_init(&ctx);
    EVP_DecryptInit_ex(&ctx, cipher, NULL, (unsigned char *)key, (unsigned char *)iv);

    int plain_length, final_length;
    unsigned char *plaintext;

    plain_length = data_length;
    plaintext = (unsigned char *)malloc(plain_length + 1);

    EVP_DecryptUpdate(&ctx, plaintext, &plain_length, (unsigned char *)data, data_length);
    EVP_DecryptFinal_ex(&ctx, plaintext + plain_length, &final_length);

    plaintext[plain_length + final_length] = '\0';

    QString output = (char *)plaintext;
    free(plaintext);

    EVP_CIPHER_CTX_cleanup(&ctx);

    return output;
}
