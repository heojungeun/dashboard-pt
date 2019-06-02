var fs = require('fs');
var http = require('http');
var url = require('url');
var port = 3000;
var bodyParser = require('body-parser');
var session = require('express-session');
var express = require('express');
var app = express();
var ejs = require('ejs');

app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');
app.engine('html', require('ejs').renderFile);

var server = app.listen(port, function(){
    console.log("Express server has started on port 3000")
});

app.use(express.static('views'));

// =========================
app.use(bodyParser.json());
app.use(bodyParser.urlencoded());
app.use(session({
 secret: '@#@$MYSIGN#@$#$',
 resave: false,
 saveUninitialized: true
}));

var router = require('./router/main')(app,fs);


// function start(route,handle) {
//     function onRequest(request, response) {
//         var pathname = url.parse(request.url).pathname;
//         console.log('request for ' + pathname + ' received.');
//
//         route(handle,pathname, response); // injected function call
//     }
//
//     http.createServer(onRequest).listen(port);
//
//     console.log('server has started. http://127.0.0.1:',port);
// }

// function start() {
//     function onRequest(request, response) {
//         console.log('request received.');
//         response.writeHead(200, {'Content-Type' : 'text/plain'});
//         response.write('Hello World');
//         response.end();
//     }
//
//     http.createServer(onRequest).listen(port);
//
//     console.log('server has started.');
// }
//
// exports.start = start;
