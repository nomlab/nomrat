/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
           ______     ______     ______   __  __     __     ______
          /\  == \   /\  __ \   /\__  _\ /\ \/ /    /\ \   /\__  _\
          \ \  __<   \ \ \/\ \  \/_/\ \/ \ \  _"-.  \ \ \  \/_/\ \/
           \ \_____\  \ \_____\    \ \_\  \ \_\ \_\  \ \_\    \ \_\
            \/_____/   \/_____/     \/_/   \/_/\/_/   \/_/     \/_/


This is a sample Slack bot built with Botkit.

This bot demonstrates many of the core features of Botkit:

* Connect to Slack using the real time API
* Receive messages based on "spoken" patterns
* Reply to messages
* Use the conversation system to ask questions
* Use the built in storage system to store and retrieve information
  for a user.

# RUN THE BOT:

  Get a Bot token from Slack:

    -> http://my.slack.com/services/new/bot

  Run your bot from the command line:

    token=<MY TOKEN> node bot.js

# USE THE BOT:

  Find your bot inside Slack to send it a direct message.

  Say: "Hello"

  The bot will reply "Hello!"

  Say: "who are you?"

  The bot will tell you its name, where it running, and for how long.

  Say: "Call me <nickname>"

  Tell the bot your nickname. Now you are friends.

  Say: "who am I?"

  The bot will tell you your nickname, if it knows one for you.

  Say: "shutdown"

  The bot will ask if you are sure, and then shut itself down.

  Make sure to invite your bot into other channels using /invite @<my bot>!

# EXTEND THE BOT:

  Botkit is has many features for building cool and useful bots!

  Read all about it here:

    -> http://howdy.ai/botkit

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/


var ConfigFile = require('config');
if (!ConfigFile.token) {
    console.log('Error: Specify token in config/default.yaml');
    process.exit(1);
}

var Botkit = require('botkit');
var os = require('os');
var XMLHttpRequest = require('xhr2')

var controller = Botkit.slackbot({
    debug: true,
    retry: Infinity,
});

var bot = controller.spawn({
    token: ConfigFile.token
}).startRTM();


// controller.hears(['hello','hi'],'direct_message,direct_mention,mention',function(bot, message) {

//     bot.api.reactions.add({
//         timestamp: message.ts,
//         channel: message.channel,
//         name: 'robot_face',
//     },function(err, res) {
//         if (err) {
//             bot.botkit.log('Failed to add emoji reaction :(',err);
//         }
//     });


//     controller.storage.users.get(message.user,function(err, user) {
//         if (user && user.name) {
//             bot.reply(message,'Hello ' + user.name + '!!');
//         } else {
//             bot.reply(message,'Hello.');
//         }
//     });
// });

controller.hears([''],'rtm_close',function(bot, message) {
    bot = controller.spawn({
        token: ConfigFile.token
    }).startRTM();
});

controller.hears(['call me (.*)'],'direct_message,direct_mention,mention',function(bot, message) {
    var matches = message.text.match(/call me (.*)/i);
    var name = matches[1];
    controller.storage.users.get(message.user,function(err, user) {
        if (!user) {
            user = {
                id: message.user,
            };
        }
        user.name = name;
        controller.storage.users.save(user,function(err, id) {
            bot.reply(message,'Got it. I will call you ' + user.name + ' from now on.');
        });
    });
});

controller.hears(['what is my name','who am i'],'direct_message,direct_mention,mention',function(bot, message) {

    controller.storage.users.get(message.user,function(err, user) {
        if (user && user.name) {
            bot.reply(message,'Your name is ' + user.name);
        } else {
            bot.reply(message,'I don\'t know yet!');
        }
    });
});


controller.hears(['shutdown'],'direct_message,direct_mention,mention',function(bot, message) {

    bot.startConversation(message,function(err, convo) {

        convo.ask('Are you sure you want me to shutdown?',[
            {
                pattern: bot.utterances.yes,
                callback: function(response, convo) {
                    convo.say('Bye!');
                    convo.next();
                    setTimeout(function() {
                        process.exit();
                    },3000);
                }
            },
        {
            pattern: bot.utterances.no,
            default: true,
            callback: function(response, convo) {
                convo.say('*Phew!*');
                convo.next();
            }
        }
        ]);
    });
});


controller.hears(['uptime','identify yourself','who are you','what is your name'],'direct_message,direct_mention,mention',function(bot, message) {

    var hostname = os.hostname();
    var uptime = formatUptime(process.uptime());

    bot.reply(message,':robot_face: I am a bot named <@' + bot.identity.name + '>. I have been running for ' + uptime + ' on ' + hostname + '.');

});

controller.hears([''],'ambient,file_share',function(bot, message) {

    if (message.file){
        if (message.file.mimetype.match(new RegExp(/^image/))){
            console.log(message.file)
            const request = require('request');
            var fs = require('fs');
            var url = message.file.url_private_download
            var pinatra = ConfigFile.pinatra
            request(
                {method: 'GET', url: url, encoding: null, headers: {'Authorization': 'Bearer '+ConfigFile.token}},
                function (error, response, body){
                    if(!error && response.statusCode === 200){
                        var binary = body;
                        fs.writeFileSync(./img/ + message.file.name.replace(/\s/g, "_"), body, 'binary');
                        var album_id = ConfigFile.album_id.auto_buckup
                        var exec = require('child_process').exec;
                        var cmd;
                        cmd = 'curl ' +
                            '-F file1=@'+ ./img/ + message.file.name.replace(/\s/g, "_") +
                            " " + pinatra + '/' + album_id + '/photo/new';
                        execCmd = function() {
                            return exec(cmd, {timeout: 100000},
                                        function(error, stdout, stderr) {
                                            console.log('stdout: '+(stdout||'none'));
                                            console.log('stderr: '+(stderr||'none'));
                                            if(error !== null) {
                                                console.log('exec error: '+error);
                                            }
                                            if(stdout !== null) {
                                                var res = JSON.parse(stdout)
                                                bot.reply(message,'Successfully uploaded: ' + res[0]["title"] + "\n" + res[0]["src"]);
                                                fs.unlink(dir_path + message.file.name.replace(/\s/g, "_"), function (err) {
                                                    if (err) throw err;
                                                    console.log('successfully deleted '+message.file.name.replace(/\s/g, "_"));
                                                });
                                            }
                                        }
                                       )
                        };
                        execCmd();
                        // var req = request.post(pinatra, function (err, resp, body) {
                        //     if (err) {
                        //         console.log('Error!:' + err);
                        //     } else {
                        //         console.log('URL: ' + body);
                        //     }
                        // });
                        // var form = req.form();
                        // form.append('file', fs.readFileSync('./' + message.file.name), {
                        //     filename: message.file.name,
                        //     contentType: message.file.mimetype
                        // });
                    }
                }
            );
        }
    }
});

controller.hears(['と検索'],'direct_message,direct_mention,mention',function(bot, message) {

    var matches = message.text.match(/(.*)と検索$/);
    var word = matches[1];
    var exec = require('child_process').exec;
    var cmd;

    cmd = './plugins/search_wiki/bin/search_wiki ' + word;
    execCmd = function() {
        return exec(cmd, {timeout: 100000},
                    function(error, stdout, stderr) {
                        console.log('stdout: '+(stdout||'none'));
                        console.log('stderr: '+(stderr||'none'));
                        if(error !== null) {
                            console.log('exec error: '+error);
                        }
                        bot.reply(message,stdout);
                    }
                   )
    };
    execCmd();

});

// controller.hears([''],'direct_message,direct_mention',function(bot, message) {

//     var tokens,nouns='';

//     console.log("-----------analysis----------");
//     console.log(message.text);
//     var DIC_URL, kuromoji, tokenizer;
//     kuromoji = require('kuromoji');
//     tokenizer = null;
//     DIC_URL = "node_modules/kuromoji/dist/dict/";

//     kuromoji.builder({
//         dicPath: DIC_URL
//     }).build(function(err, _tokenizer) {
//         tokenizer = _tokenizer;
//         tokens = tokenizer.tokenize(message.text);
//         tokens.forEach(
//             function specifyNoun(token){
//                 if(token.pos == '名詞'){
//                     nouns = nouns + token.basic_form + ' ';
//                 }
//             }
//         )
//         bot.reply(message,nouns.substr(0, nouns.length-1));

//         var exec = require('child_process').exec;
//         var cmd;

//         cmd = '/Users/yoshidahisashi/myexperiment/search_wiki/bin/search_wiki ' + nouns.substr(0, nouns.length-1);
//         console.log(cmd)
//         execCmd = function() {
//             return exec(cmd, {timeout: 100000},
//                         function(error, stdout, stderr) {
//                             console.log('stdout: '+(stdout||'none'));
//                             console.log('stderr: '+(stderr||'none'));
//                             if(error !== null) {
//                                 console.log('exec error: '+error);
//                             }
//                             bot.reply(message,stdout);
//                         }
//                        )
//         };
//         execCmd();
//     });

// });

function formatUptime(uptime) {
    var unit = 'second';
    if (uptime > 60) {
        uptime = uptime / 60;
        unit = 'minute';
    }
    if (uptime > 60) {
        uptime = uptime / 60;
        unit = 'hour';
    }
    if (uptime != 1) {
        unit = unit + 's';
    }

    uptime = uptime + ' ' + unit;
    return uptime;
}
