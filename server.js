var express = require('express'),
	winston = require('winston'),
	app = express(),
	oneDay = 86400000,
	port = process.env.PORT || 3333;

// enable web server logging piped through winston
var winstonStream = {
    write: function(message, encoding){
        winston.info(message);
    }
};

app.use(express.logger({stream:winstonStream}));
app.use(express.compress());
app.use(express.static(__dirname + '/public', {maxAge: oneDay}));
app.use(function(req, res) {
	var newUrl = req.protocol + '://' + req.get('Host') + '/#' + req.url;
	return res.redirect(newUrl);
});

app.listen(port, function() {console.log("listening on " + port);});