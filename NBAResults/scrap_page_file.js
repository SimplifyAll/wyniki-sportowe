// scrap_page_file.js

                                var webPage = require('webpage');
                                var page = webPage.create();

                                var fs = require('fs');
                                var path = 'page_file.html'

                                page.open('http://www.oddsportal.com/basketball/usa/nba-2010-2011/results/#/page/1/', function (status) {
                                var content = page.content;
                                fs.write(path,content,'w')
                                phantom.exit();
                                });
