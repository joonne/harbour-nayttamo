.import "http.js" as HTTP
.import "promise.js" as Promise

var api = (function(appId, appKey) {

     var apiUrl = "https://external.api.yle.fi/v1";

     // .env -> qmake -> DEFINES -> setContextProperty
     var credentials = "app_id=" + appId + "&app_key=" + appKey;

     var programsUrl = "/programs/items.json?" + credentials + "&contentprotection=22-0,22-1&availability=ondemand&mediaobject=video";
     var categoriesUrl = "/programs/categories.json?" + credentials;
     var programDetailsUrl = "/programs/items/1-820561.json" + "?" + credentials;
     var mediaUrl = "/media/playouts.json?"+ credentials;
     var trackingUrl = "/tracking/streamstart?" + credentials;
     var currentBroadcastUrl = "/programs/schedules/now.json?" + credentials;
     var servicesUrl = "/programs/services.json?" + credentials;

     var handleError = function(caller, callback) {
         return function(error) {
             console.log(caller, JSON.stringify(error));
             callback(error);
         };
     };

     var filterAvailablePrograms = function(programs) {
         return programs.reduce(function(acc, program) {
             var foundPublicationEvents = program.publicationEvent.filter(function(event) {
                 return event.temporalStatus === "currently" && event.type === "OnDemandPublication" && event.media && event.media.available;
             });

             if (foundPublicationEvents.length) {
                 program.publicationEvent = foundPublicationEvents[0]; // TODO: check this
                 acc.push(program);
             }

             return acc;
         }, []);
     };

     function formatProgramDetails(seasonNumber, episodeNumber) {
         if (seasonNumber && episodeNumber) {
             return qsTr("Season %1 Episode %2").arg(seasonNumber).arg(episodeNumber);
         } else if (seasonNumber) {
             return qsTr("Season %1").arg(seasonNumber);
         } else if (episodeNumber) {
             return qsTr("Episode %1").arg(episodeNumber);
         }
         return "";
     }

     function zeropad(str, size) {
         var tmpStr = str;
         while (tmpStr.length < size) {
             tmpStr = "0" + tmpStr;
         }
         return tmpStr;
     }

     function formatTime(milliseconds) {
         var minutes = zeropad(String(Math.floor((milliseconds / 1000) / 60)), 2);
         var seconds = zeropad(String(Math.floor((milliseconds / 1000) % 60)), 2);
         return minutes + ":" + seconds;
     }

     function parseDuration(duration) {//PT1H58M45S
         if (!duration) {
             return "";
         }

         var previousSepIndex = 0;
         var durationStr = duration.substr(2);
         var sepIndex = durationStr.indexOf("H");
         var hour = durationStr.substr(0, sepIndex);
         previousSepIndex = sepIndex >= 0 ? sepIndex + 1 : previousSepIndex;
         sepIndex = durationStr.indexOf("M");
         var min = sepIndex >= 0 ? durationStr.substring(previousSepIndex, sepIndex) : "0";
         previousSepIndex = sepIndex >= 0 ? sepIndex + 1 : previousSepIndex;
         sepIndex = durationStr.indexOf("S");
         var sec = sepIndex >= 0 ? zeropad(durationStr.substring(previousSepIndex, sepIndex), 2) : "00";

         return "" + (hour ? hour + ":" + zeropad(min, 2) : zeropad(min, 1)) + ":" + sec;
     }

     function parseTime(timeStr) {//2014-01-23T21:00:07+02:00
         if (!timeStr) {
             return "";
         }
         return Qt.formatDateTime(new Date(timeStr));
     }

     var mapPrograms = function(programs) {
         return programs.map(function(program) {
             var seriesTitle = program.partOfSeries && program.partOfSeries.title && program.partOfSeries.title.fi;
             var programTitle = program.title && program.title.fi || "";
             var shortDescription = seriesTitle && programTitle && seriesTitle !== programTitle ? programTitle : (program.shortDescription && program.shortDescription.fi || "");

             return {
                 id: program.id,
                 title: seriesTitle ? seriesTitle : programTitle,
                 shortDescription: shortDescription,
                 description: program.description && program.description.fi,
                 duration: parseDuration(program.duration),
                 startTime: program.publicationEvent && program.publicationEvent.startTime && parseTime(program.publicationEvent.startTime),
                 mediaId: program.publicationEvent && program.publicationEvent.media && program.publicationEvent.media.id,
                 image: program.image,
                 seasonNumber: program.partOfSeason && program.partOfSeason.seasonNumber
                               ? program.partOfSeason.seasonNumber
                               : "",
                 episodeNumber: program.episodeNumber ? program.episodeNumber : "",
                 seriesId: program.partOfSeries && program.partOfSeries.id
              };
         });
     }

     function getProgramById(id) {
         return HTTP.get(apiUrl + "/programs/items/" + id + ".json?" + credentials)
             .catch(handleError("getProgramById", function() { return {}; }));
     }

     function getProgramsByCategoryId(categoryId, limit, offset) {
         var url = apiUrl + programsUrl + '&category=' + categoryId + '&offset=' + offset + '&limit=' + limit;
         return HTTP.get(url)
             .then(function(response) { return response.data; })
             .then(filterAvailablePrograms)
             .then(mapPrograms);
     }

     function getProgramsBySeriesId(seriesId, limit, offset) {
         var url = apiUrl + programsUrl + '&series=' + seriesId + '&offset=' + offset + '&limit=' + limit;
         return HTTP.get(url)
             .then(function(response) { return response.data; })
             .then(filterAvailablePrograms)
             .then(mapPrograms);
     }

     function getCategories() {
         var url = apiUrl + categoriesUrl;
         return HTTP.get(url)
             .then(function(res) {
                 return res.data.map(function(category) {
                     return {
                         id: category.id,
                         title: category.title.fi,
                         key: category.key
                     };
                 });
             });
     }

     function decryptUrl(url) {
         return urlDecrypt.decryptUrl(url);
     }

     function findSubtitlesUrlByLanguage(language, subtitles) {
         var foundSubtitles = subtitles.filter(function(item) {
             return item.lang === language;
         });

         return foundSubtitles && foundSubtitles[0] && foundSubtitles[0].uri;
     }

     function getMediaUrl(programId, mediaId, protocol) {
         var url = [apiUrl, mediaUrl, "&program_id=", programId, "&media_id=", mediaId, "&protocol=", protocol || "HLS"].join("");

         return HTTP.get(url)
             .then(function(res) {
                 return {
                     subtitlesUrl: res.data && res.data[0] && res.data[0].subtitles && findSubtitlesUrlByLanguage("fi", res.data[0].subtitles) || '',
                     url: decryptUrl(res.data[0].url),
                 };
             });
     }

     function search(text, limit, offset) {
         var url = apiUrl + programsUrl + '&q=' + text + '&offset=' + offset + '&limit=' + limit;
         return HTTP.get(url)
             .then(function(response) { return response.data; })
             .then(filterAvailablePrograms)
             .then(mapPrograms)
             .catch(handleError("search", function(error) { throw error; }));
     }

     function reportUsage(programId, mediaId) {
         var url = apiUrl + trackingUrl + "&program_id=" + programId + "&media_id=" + mediaId;
         return HTTP.get(url);
     }

     function getServices() {
         var tvChannelsUrl = apiUrl + servicesUrl + "&type=tvchannel";
         var onDemandServiceUrl = apiUrl + servicesUrl + "&type=ondemandservice";
         var webcastServiceUrl = apiUrl + servicesUrl + "&type=webcastservice";

         return Promise.all([
             HTTP.get(tvChannelsUrl),
             HTTP.get(onDemandServiceUrl),
             HTTP.get(webcastServiceUrl)
         ])
             .then(function(serviceResponses) {
                 return serviceResponses.reduce(function(services, serviceResponse) {
                     return services.concat(serviceResponse.data);
                 }, []);
             })
             .then(function(services) {
                 return services.map(function(service) {
                     return service.id;
                 });
             })
             .catch(handleError("getServices", function() { return []; }));
     }

     function getCurrentBroadcasts() {
         return getServices()
             .then(function(services) {
                 var url = apiUrl + currentBroadcastUrl + "&service=" + services.join(',') + "&start=0&end=0";
                 return HTTP.get(url)
                     .then(function(response) {
                         return response.data.map(function(res) {
                             return res.content;
                         });
                     })
                     .then(filterAvailablePrograms)
                     .then(mapPrograms)
                     .catch(handleError("getCurrentBroadcasts", function() { return []; }));
             });
     }

    function getRadioServices() {
        var radioChannelsUrl = [apiUrl, servicesUrl, "&type=radiochannel"].join("");

        return HTTP.get(radioChannelsUrl)
            .then(function(response) { return response.data; })
            .then(function(services) { return services.map(function(service) { return service.id; }) })
            .catch(handleError("getRadioServices", function() { return []; }));
    }

    function getCurrentRadioBroadcasts() {
        return getRadioServices()
            .then(function(services) {
                var url = apiUrl + currentBroadcastUrl + "&service=" + services.join(',') + "&start=0&end=0";
                return HTTP.get(url)
            })
            .then(function(response) {
                return response.data.map(function(res) {
                    return res.content;
                })
            })
            .then(filterAvailablePrograms)
            .then(mapPrograms)
            .catch(handleError("getCurrentRadioBroadcasts", function() { return []; }));
    }

    function getNowPlayingRadioPrograms() {
        function getNowPlayingRadioProgramUrl(id) {
            return [apiUrl, "/programs/nowplaying/", id, ".json", "?", credentials].join("");
        }

        function resolvePromise(promise) {
            return promise
                .then(function(result) { return result })
                .catch(function(error) { return {} });
        }

        return getRadioServices()
            .then(function(services) {
                return Promise.all(services.map(function(service) {
                    var url = getNowPlayingRadioProgramUrl(service);
                    return resolvePromise(HTTP.get(url));
                }));
            })
            .then(function(results) {
                return results.reduce(function(allServices, result) {
                    return allServices.concat(result.data || []);
                }, []);
            })
            .then(function(allServices) {
                return allServices.filter(function(service) {
                    return service.delta === "1";
                });
            })
            .then(function(programs) {
                return Promise.all(programs.map(function(program) {
                    var programId = program && program.service && program.service.id;
                    var mediaId = program && program.service && program.service.outlet && program.service.outlet.length && program.service.outlet[0] && program.service.outlet[0].media && program.service.outlet[0].media.id;
                    console.log(programId, mediaId);

                    if (!programId || !mediaId) return Promise.resolve(program);

                    return getMediaUrl(programId, mediaId)
                        .then(function(result) {
                            program.mediaUrl = result;
                            return program;
                        })
                        .catch(function(error) { console.log(JSON.stringify(error, null, 2)); return program; });
                }));
            })
            .catch(handleError("getNowPlayingRadioPrograms", function() { return []; }));
    }

     return {
         formatTime: formatTime,
         formatProgramDetails: formatProgramDetails,
         getCategories: getCategories,
         getCurrentBroadcasts: getCurrentBroadcasts,
         getMediaUrl: getMediaUrl,
         reportUsage: reportUsage,
         getProgramById: getProgramById,
         getProgramsByCategoryId: getProgramsByCategoryId,
         getProgramsBySeriesId: getProgramsBySeriesId,
         search: search,
         getCurrentRadioBroadcasts: getCurrentRadioBroadcasts,
     };
 })(appId, appKey);

function formatTime() { return api.formatTime.apply(null, arguments); }
function formatProgramDetails() { return api.formatProgramDetails.apply(null, arguments); }
function getCategories() { return api.getCategories.apply(null, arguments); }
function getCurrentBroadcasts() { return api.getCurrentBroadcasts.apply(null, arguments); }
function getMediaUrl() { return api.getMediaUrl.apply(null, arguments); }
function reportUsage() { return api.reportUsage.apply(null, arguments); }
function getProgramById() { return api.getProgramById.apply(null, arguments); }
function getProgramsByCategoryId() { return api.getProgramsByCategoryId.apply(null, arguments); }
function getProgramsBySeriesId() { return api.getProgramsBySeriesId.apply(null, arguments); }
function search() { return api.search.apply(null, arguments); }
function getCurrentRadioBroadcasts() { return api.getCurrentRadioBroadcasts.apply(null, arguments); }
