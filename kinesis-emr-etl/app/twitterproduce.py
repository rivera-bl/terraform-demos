from tweepy.streaming import StreamListener
from tweepy import OAuthHandler
from tweepy import Stream
import json
import boto3
import time
import vars

# import twitter_credentials
from helper.extract_tweet_info import extract_tweet_info


class TweetStreamListener(StreamListener):
    # on success
    def on_data(self, data):
        """Overload this method to have some processing on the data before putting it into kiensis data stream
        """
        tweet = json.loads(data)

        try:
            payload = extract_tweet_info(tweet)
            # only put the record when message is not None
            if (payload):
                print(payload)
                # note that payload is a list
                put_response = kinesis_client.put_record(
                    StreamName=vars.STREAM_NAME,
                    Data=payload,
                    PartitionKey=str(tweet['user']['screen_name'])
                )

            return True
        except (AttributeError, Exception) as e:
            print(e)


    def on_error(self, status):
        print(status)


if __name__ == '__main__':
    # create kinesis client connection
    # is this necessary if we are using an Instance role?
    # session = boto3.Session(profile_name='your_aws_profile')
    session = boto3.Session()

    # create the kinesis client
    kinesis_client = session.client('kinesis', region_name='us-east-1')

    # set twitter keys/tokens
    auth = OAuthHandler(vars.TWITTER_API_KEY, vars.TWITTER_API_SECRET)
    auth.set_access_token(vars.TWITTER_ACCESS_TOKEN, vars.TWITTER_ACCESS_SECRET)

    while True:
        try:
            print('Twitter streaming...')

            # create instance of the tweet stream listener
            myStreamlistener = TweetStreamListener()

            # create instance of the tweepy stream
            stream = Stream(auth=auth, listener=myStreamlistener)

            # search twitter for the keyword
            stream.filter(track=["#AI", "#MachineLearning"], languages=['en'], stall_warnings=True)
        except Exception as e:
            print(e)
            print('Disconnected...')
            time.sleep(5)
            continue
