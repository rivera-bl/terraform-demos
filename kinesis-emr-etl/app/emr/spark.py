from operator import add
from pyspark.sql import SparkSession
import vars

def main():

    # Create our Spark Session via a SparkSession builder
    spark = SparkSession.builder.appName("PySpark Example").getOrCreate()

    print("Read in a file from S3 with the s3a file protocol")
    # Read in a file from S3 with the s3a file protocol
    # (This is a block based overlay for high performance supporting up to 5TB)
    text = spark.read.text(vars.SOURCE_S3)

    # You can print out the text to the console like so:
    text.show()

    text.write.text(vars.DESTINATION_S3)
    
    # Make sure to call stop() otherwise the cluster will keep running and cause problems for you
    spark.stop()

main()
