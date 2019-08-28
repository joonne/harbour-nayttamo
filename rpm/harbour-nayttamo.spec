# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
# 

Name:       harbour-nayttamo

# >> macros
# << macros

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    harbour-nayttamo
Version:    0.2
Release:    1
Group:      Qt/Qt
License:    MIT and BSD
URL:        https://github.com/joonne/harbour-nayttamo
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-nayttamo.yaml
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(libcrypto)
BuildRequires:  desktop-file-utils

%description
Native YLE Areena application for Sailfish OS


%package test
Summary:    Tests for harbour-nayttamo
Group:      Qt/Qt
Requires:   %{name} = %{version}-%{release}
Requires:   qt5-qtdeclarative-import-qttest
BuildRequires:  pkgconfig(Qt5QuickTest)

%description test
Tests package for harbour-nayttamo

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qtc_qmake5  \
    VERSION=%{version} \
    RELEASE=%{release}

%qtc_make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}/qml
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
# >> files
# << files

%files test
%defattr(-,root,root,-)
%{_bindir}/tst-harbour-nayttamo
%{_datadir}/tst-harbour-nayttamo/*.qml
%attr(0755,-,-) %{_datadir}/tst-harbour-nayttamo/*.sh
# >> files test
# << files test
