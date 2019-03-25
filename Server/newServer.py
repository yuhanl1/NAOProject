#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
newServer.py
The server is started when newServer.py is run from the command line:
> python newServer.py
See the usage string for more details.
> python newServer.py --help

@author: Yuhan Liu 802997 University of Melbourne
@version: 1.41
@Date: March - May, 2018
"""
import socket
import thread
import almath
import random
import sys
from naoqi import ALProxy
from naoqi import ALBroker
from naoqi import ALModule
import vision_definitions
import numpy as np
from CryClassifier import CryClassifier
from optparse import OptionParser





class OpenCVModule():
    def __init__(self, IP, PORT, CameraID = 0, X=240, Y=320):
        self._x = X
        self._y = Y
        self.ip= IP
        self.port = PORT
        self._videoProxy = None
        self._cameraID = CameraID

        #Configure YUV422 images
        if self._x == 30 and self._y == 40:
            self._resolution = vision_definitions.kQQQQVGA
            self._fps = 30
        elif self._x == 60 and self._y == 80:
            self._resolution = vision_definitions.kQQQVGA
            self._fps = 30
        elif self._x == 120 and self._y == 160:
            self._resolution = vision_definitions.kQQVGA
            self._fps = 30
        elif self._x == 240 and self._y == 320:
            self._resolution = vision_definitions.kQVGA
            self._fps = 11
        elif self._x == 480 and self._y == 640:
            self._resolution = vision_definitions.kVGA
            self._fps = 2.5
        elif self._x == 960 and self._y == 1280:
            self._resolution = vision_definitions.k4VGA
            self._fps = 0.5
        else:
            self._resolution = vision_definitions.kQVGA
            self._fps = 30

        self._colorSpace = vision_definitions.kBGRColorSpace
        self._imgClient = ""
        self._imgData = None
        self._img = np.zeros((self._x, self._y, 3), np.uint8)

        self._registerImageClient(IP, PORT)

    def _registerImageClient(self, IP, PORT):
        self._videoProxy = ALProxy("ALVideoDevice", IP, PORT)
        for i in self._videoProxy.getSubscribers():
            print self._videoProxy.unsubscribe(i)
        self._imgClient = self._videoProxy.subscribeCamera("OpenCVModule", self._cameraID, self._resolution,
                                                           self._colorSpace, self._fps)

    def unregisterImageClient(self):
        if self._imgClient != "":
            self._videoProxy.unsubscribe(self._imgClient)

    def getImage(self):
        try:
            self._imgData = self._videoProxy.getImageRemote(self._imgClient)
            b = np.asarray(bytearray(self._imgData[6]), dtype="uint8")
            tmp_b = b.reshape((self._x, self._y, 3))
            tmp_b[:,:,[0,2]] = tmp_b[:,:,[2,0]]
            tmp_b = tmp_b.reshape(self._x*self._y*3)
            return bytearray(tmp_b)
            #self._img = b.reshape((self._x, self._y, 3))
        except:
            return 'ERROR'

    def updateResolution(self,newX,newY):
        self._x = newX
        self._y = newY
        if newX == 30 and newY == 40:
            self._resolution = vision_definitions.kQQQQVGA
            self._fps = 30
        elif newX == 60 and newY == 80:
            self._resolution = vision_definitions.kQQQVGA
            self._fps = 30
        elif newX == 120 and newY == 160:
            self._resolution = vision_definitions.kQQVGA
            self._fps = 30
        elif newX == 240 and newY == 320:
            self._resolution = vision_definitions.kQVGA
            self._fps = 11
        elif newX == 480 and newY == 640:
            self._resolution = vision_definitions.kVGA
            self._fps = 2.5
        elif newX == 960 and newY == 1280:
            self._resolution = vision_definitions.k4VGA
            self._fps = 0.5
        else:
            self._resolution = vision_definitions.kQVGA
            self._fps = 30
        self.unregisterImageClient()
        self._registerImageClient(self.ip,self.port)

class reactToTouchModule(ALModule):

    def __init__(self, name):

        ALModule.__init__(self, name)

        memory.subscribeToEvent("FrontTactilTouched", "reactToTouch", "onHeadFrontTouched")
        memory.subscribeToEvent("MiddleTactilTouched", "reactToTouch", "onHeadMiddleTouched")
        memory.subscribeToEvent("RearTactilTouched", "reactToTouch", "onHeadRearTouched")
        memory.subscribeToEvent("HandRightBackTouched", "reactToTouch", "onRightTouched")
        memory.subscribeToEvent("HandLeftBackTouched", "reactToTouch", "onLeftTouched")

        self.leftCount = 0
        self.rightCount = 0
        self.frontCount = 0
        self.middleCount = 0
        self.rearCount = 0

        self.fairyList = []
        self.lullabyList = []
        player.unloadAllFiles()

        for i in range(9):
            i = i + 1
            filename= "/home/nao/fairy/0"+i.__str__()+".mp3"
            tmp = player.loadFile(filename)
            self.fairyList.append(tmp)
        for i in range(10,16):
            filename= "/home/nao/fairy/"+i.__str__()+".mp3"
            tmp = player.loadFile(filename)
            self.fairyList.append(tmp)
        for i in range(10):
            i = i + 1
            filename= "/home/nao/lullaby/Lullaby ("+i.__str__()+").mp3"
            tmp = player.loadFile(filename)
            self.lullabyList.append(tmp)
        #print self.fairyList
        #print self.lullabyList

        self.lullabyPlayID = self.lullabyList[0]
        self.fairyPlayID = self.fairyList[0]

    def onRightTouched(self, strVarName, value):
        player.stopAll()
        index = random.randint(0,len(self.fairyList) - 1)
        self.fairyPlayID = self.fairyList[index]
        #print self.fairyPlayID
        self.leftCount += 0.5
        if self.leftCount % 1 == 0:
            player.play(self.fairyPlayID)

    def onLeftTouched(self, strVarName, value):
        self.rightCount += 0.5
        #print self.rightCount
        if self.rightCount % 2 == 0:
            player.play(self.fairyPlayID)
        else:
            player.pause(self.fairyPlayID)

    def onHeadMiddleTouched(self, strVarName, value):
        self.middleCount += 0.5
        if self.middleCount % 2 == 1:
            player.play(self.lullabyPlayID)
        elif self.middleCount % 2 == 0:
            player.pause(self.lullabyPlayID)

    def onHeadFrontTouched(self, strVarName, value):
        player.stopAll()
        pre_index = self.lullabyList.index(self.lullabyPlayID)
        index = 0
        if pre_index > 0:
            index = pre_index - 1

        self.lullabyPlayID = self.lullabyList[index]
        self.middleCount = 1
        #print self.lullabyPlayID
        if index % 2 == 0:
            player.play(self.lullabyPlayID)


    def onHeadRearTouched(self, strVarName, value):
        player.stopAll()
        pre_index = self.lullabyList.index(self.lullabyPlayID)
        index = len(self.lullabyList) - 1
        if pre_index < len(self.lullabyList) - 1:
            index = pre_index + 1

        self.lullabyPlayID = self.lullabyList[index]
        self.middleCount = 1
        #print self.lullabyPlayID
        if index % 2 == 0:
            player.play(self.lullabyPlayID)

    def playASong(self,index):
        player.stopAll()
        if index<0:
            index = 0
        if index>len(self.lullabyList) - 1:
            index = len(self.lullabyList) - 1

        try:
            self.lullabyPlayID = self.lullabyList[index]
            player.play(self.lullabyPlayID)
        except BaseException,err:
            print str(err)

    def playAStory(self,index):
        player.stopAll()
        if index<0:
            index = 0
        if index>len(self.fairyList) - 1:
            index = len(self.fairyList) - 1
        try:
            self.fairyPlayID = self.fairyList[index]
            player.play(self.fairyPlayID)
        except BaseException, err:
            print str(err)

    def stopAll(self):
        player.stopAll()

    def pauseSong(self):
        try:
            player.pause(self.lullabyPlayID)
        except BaseException, err:
            print str(err)

    def pauseStory(self):
        try:
            player.pause(self.fairyPlayID)
        except BaseException, err:
            print str(err)

    def replaySong(self):
        try:
            player.play(self.lullabyPlayID)
        except BaseException, err:
            print str(err)

    def replayStory(self):
        try:
            player.play(self.fairyPlayID)
        except BaseException, err:
            print str(err)

class SoundReceiverModule(ALModule):

    def __init__( self, strModuleName):
        try:
            ALModule.__init__(self, strModuleName )
            self.BIND_PYTHON( self.getName(),"callback")
            self.outfile = None
            self.aOutfile = [None]*(4-1) # ASSUME max nbr channels = 4
            self.cryClf = CryClassifier()
            self.count = 0
            self.tmpAudioData = np.empty(0)
        except BaseException, err:
            print str(err)

    def __del__( self ):
        #print "INF: abcdk.SoundReceiverModule.__del__: cleaning everything"
        self.stop()

    def start( self ):

        nNbrChannelFlag = 3 # ALL_Channels: 0,  AL::LEFTCHANNEL: 1, AL::RIGHTCHANNEL: 2; AL::FRONTCHANNEL: 3  or AL::REARCHANNEL: 4.
        nDeinterleave = 0
        self.nSampleRate = 48000
        audio.setClientPreferences( self.getName(),  self.nSampleRate, nNbrChannelFlag, nDeinterleave )
        audio.subscribe( self.getName() )
        print( "INF: SoundReceiver: started!" )

    def stop( self ):
        #print( "INF: SoundReceiver: stopping..." )
        audio.unsubscribe( self.getName() )
        #print( "INF: SoundReceiver: stopped!" )
        if( self.outfile != None ):
            self.outfile.close()


    def processRemote( self, nbOfChannels, nbrOfSamplesByChannel, aTimeStamp, buffer ):

        aSoundDataInterlaced = np.fromstring( str(buffer), dtype=np.int16 )

        aSoundData = np.reshape( aSoundDataInterlaced, (nbOfChannels, nbrOfSamplesByChannel), 'F' )
        self.count += 1
        self.tmpAudioData = np.append(self.tmpAudioData, aSoundData[0].astype(float))
        if self.count == 100:
            try:
                result = self.cryClf.detectCryByRawData(self.tmpAudioData, 8000)
                if result == "Cry":
                    tts.say("Do not cry, baby, mom is coming. What if I play a song for you?")
                    tts.say("Or you can touch my right arm. I can tell you a fairy tale.")
                    motionProxy.setAngles('RShoulderPitch', 10.0 * almath.TO_RAD, 0.1)
                    motionProxy.setAngles('RWristYaw', -70.0 * almath.TO_RAD, 0.1)
                else:
                    motionProxy.setAngles('RShoulderPitch', 75.0 * almath.TO_RAD, 0.1)
                    motionProxy.setAngles('RWristYaw', 0.0 * almath.TO_RAD, 0.1)
            except BaseException, err:
                print str(err)
            self.count = 0
            self.tmpAudioData = np.empty(0)


def child_connection(index, sock, connection):
    buf = connection.recv(1024)
    print ("Get value %s from connection %d: " % (buf, index))
    buf = str(buf)
    if buf=='Monitor':

        for i in range(1):
            tmp = videoStream.getImage()
            length = len(tmp)                   #230400
            remainder = length % 1460           #1180
            complement = 1460 - remainder       #280
            tmp += bytearray('0' * complement)
            print len(tmp)
            connection.send(tmp)
        #videoStream.unregisterImageClient()
    elif buf.startswith("Story"):
        tmpIndex = int(buf[5:])
        reactToTouch.playAStory(tmpIndex)
        print 'Play Story'
    elif buf.startswith('Song'):
        tmpIndex = int(buf[4:])
        reactToTouch.playASong(tmpIndex)
        print 'Play Song'
    elif buf.startswith('Volume'):
        try:
            newVolume = int(buf[6:])
            volumeFloat = float(newVolume) / 100.0
            tts.setVolume(volumeFloat)
            player.setVolume(volumeFloat)
        except BaseException,err:
            print str(err)
        print 'Volume'
    elif buf.startswith('Resolution'):
        newValue=buf[10:]
        valueList = newValue.split('*')
        newY= int(valueList[0])
        newX= int(valueList[1])
        videoStream.updateResolution(newX,newY)
        print 'Resolution'
    elif buf=='Stop':
        reactToTouch.stopAll()
        print 'Stop'
    elif buf.startswith('Stop'):
        print 'Stop?'
    elif buf.startswith('Say:'):
        print 'Say'
        try:
            tts.say(buf[4:])
        except BaseException,err:
            print str(err)
    connection.close()
    thread.exit_thread()


def mainProcess(robotIP,robotPort = 9559,hostIP,hostPort = 8000):
    #HOST_IP = "192.168.1.13"
    #HOST_IP = "192.168.1.100"
    HOST_IP = hostIP
    #HOST_PORT = 8000
    HOST_PORT = hostPort
    #ROBOT_IP = "192.168.1.27"
    #ROBOT_IP = "192.168.1.103"
    ROBOT_IP = robotIP
    #ROBOT_PORT = 9559
    ROBOT_PORT = robotPort

    global tts
    tts = ALProxy("ALTextToSpeech", ROBOT_IP, ROBOT_PORT)

    global player
    player = ALProxy("ALAudioPlayer", ROBOT_IP, ROBOT_PORT)

    global videoStream
    videoStream = OpenCVModule(ROBOT_IP, ROBOT_PORT, CameraID=0, X=240, Y=320)

    global motionProxy
    motionProxy = ALProxy("ALMotion", ROBOT_IP, ROBOT_PORT)
    motionProxy.wakeUp()

    global memory
    memory = ALProxy("ALMemory", ROBOT_IP, ROBOT_PORT)

    global audio
    audio = ALProxy("ALAudioDevice", ROBOT_IP, ROBOT_PORT)

    myBroker = ALBroker("myBroker", "0.0.0.0", 0, ROBOT_IP, ROBOT_PORT)

    global reactToTouch
    reactToTouch = reactToTouchModule("reactToTouch")

    global SoundReceiver
    SoundReceiver = SoundReceiverModule("SoundReceiver")
    SoundReceiver.start()

    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.bind((HOST_IP, HOST_PORT))
    sock.listen(10)
    print "listening"
    index = 0
    try:
        while True:
            connection, address = sock.accept()
            index += 1
            thread.start_new_thread(child_connection, (index, sock, connection))
    except KeyboardInterrupt:
        sock.close()
        videoStream.unregisterImageClient()
        myBroker.shutdown()
        sys.exit(0)



def readCommand(argv):
    #Processes the command.
    usageStr = """
    USAGE:      python newServer.py <options>
    OPTIONS:    --robotIP   the IP said by robot.
                --robotPort int value, typically 9559.
                --hostIP    the IP of the server, try ipconfig on Windows or ifconfig on Mac.
                --hostPort  int value, can be specified, typically 8000.
    """
    parser = OptionParser(usageStr)
    parser.add_option('--robotIP', dest='robotIP', default="192.168.0.0")
    parser.add_option('--robotPort', dest='robotPort', type='int', default=9559)
    parser.add_option('--hostIP', dest='hostIP', default="192.168.0.1")
    parser.add_option('--hostPort', dest='hostPort', type='int', default=8000)

    options, otherjunk = parser.parse_args(argv)
    if len(otherjunk) != 0:
        raise Exception('Command line input not understood: ' + str(otherjunk))
    args = dict()
    args['robotIP'] = options.robotIP
    args['robotPort'] = options.robotPort
    args['hostIP'] = options.hostIP
    args['hostPort'] = options.hostPort
    return args


if __name__ == '__main__':
    args = readCommand( sys.argv[1:] )
    mainProcess( **args )
    pass