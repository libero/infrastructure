var zlib = require('zlib');
var https = require("https");
const posttoslack = function (msg) {
  const hostname = "hooks.slack.com";
  const path = process.env.SLACK_WEBHOOK_PATH;
  return new Promise((resolve, reject) => {
    var options = {
      "method": "POST",
      "hostname": hostname,
      "path": path,
      "headers": {
        "Content-Type": "application/json"
      }
    };
    var req = https.request(options, (res) => {
      console.log('Response: ', res.statusCode)
      resolve('Success');
    });
    req.on('error', (e) => {
      reject(e.message);
    });
    // send the request
    req.write(JSON.stringify(msg));
    req.end();
  })
}

exports.lambda_handler = async function (input, context) {
  const SLACK_CHANNEL = 'sciety-errors'


  var payload = Buffer.from(input.awslogs.data, 'base64');
  console.log('payload', payload);
  const result = zlib.gunzipSync(payload)

  const parsedResult = JSON.parse(result.toString('ascii'));
  console.log("parsedResult", parsedResult);
  const blocks = parsedResult.logEvents.flatMap((logEvent) => {
    const parsedLogEvent = JSON.parse(logEvent.message);
    return [
      {
        "type": "section",
        "text": {
          "type": "plain_text",
          "text": parsedLogEvent.app_message,
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "```" + JSON.stringify(parsedLogEvent.app_payload, null, 4) + "```"
        }
      }
    ];
  });
  const slack_message = {
    'channel': SLACK_CHANNEL,
    'blocks': blocks,
  }

  console.log("pre-posttoslack");
  return posttoslack(slack_message).then(context.succeed).then(() => console.log('after context.succeed')).catch((e) => {
    console.log("caught ", e);
    context.fail(e)
  });
};
