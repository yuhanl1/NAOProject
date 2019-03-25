The folder contains 3 python files, corpus, trained model files and the files needed to copy to the robot.

Python files: 
1. newServer: the main process. 
The server is started when newServer.py is run from the command line.
USAGE:      python newServer.py <options>
OPTIONS:    --robotIP   the IP said by robot.
                    --robotPort int value, typically 9559.
                    --hostIP    the IP of the server, try ipconfig on Windows or ifconfig on Mac.
                    --hostPort  int value, can be specified, typically 8000.


2.CryClassifier.py
This is the class to train the model for cries

3.FrameFeatureExtract.py
This is the class to process the audio file
Generate the feature matrix
If need to extract again, please unzip corpus.zip first.

While running, only the data in folder 'model' need to be kept and the files in copytoRobot.zip need to be unziped and copied to the robot's root directory. Other files can be deleted.