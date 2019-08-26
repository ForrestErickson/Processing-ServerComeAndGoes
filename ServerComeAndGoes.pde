/** ServerComeAndGoes
 *
 * /author F. Lee Erickson.
 * /date 3 June 2019.
 * /brief Modified by, to indicate server status and trafic with client.
 * 
 * Transmongrafied from "Shared Drawing Canvas" (Server) Example by Alexander R. Galloway. 
 * This server has features for connection and disconnection of client and server. Developed to test embedded client connectivity.
 * A Proccessing client is also developed to allow test and development of this server. Client file name: ClientWithReconnect.  
 */

// 6 June 2019
// First work with Client Example 2 to simulate a ST365 server. 
// Ultimatly to work as a server to a ST365 which is a client.
// 7 June 2019 Server opens up on port 23 and once a client connects indicates in draw window. 
// Client data printed to console.  Mouse sends some data to client.
// The client must receive at least one character before it can disconnect with out exception.
// 11 June Connected with CC3220SocketFunction success.
// Add text into window for status and messages.
// Server responds to client message ">04" with a string.
// Server responds to client message ">05" with a string.
// 26 June 2019 Tested with the client which tries to reconnect if server is lost and is working. 
// 27 June 2019 rename from ServerLaptop to ServerComeAndGoes
// 15 July. Remove commented out code for when window was monocrome.  Improve window text and color prompts for more conditions (server not active).
// 15 July. Move keypress and mouse press to UserInput tab.  
// 26 August. Add a loging file. 

String myLogFileName = "ServerComAndGoes.log.txt";
String mySocket = "None";
String myOldSocket = "None";
Boolean Verbose = true; 

import processing.net.*;

Server myServer;
Client myClient;
Client thisClient;
int MY_PORT = 23; // Start on Telnet even though we are RAW socket.

PFont f;                          // Declare PFont variable

String input;
int data[];
int dataIn;
float myred = 0; float mygreen= 0; float myblue = 0;
color myBackground = color(255,0,0);
//int myBackground = 0;

String s_serverStatus = "Not initilized";
String s_clientStatus = "Not initilized";
String s_clientAddress = "Not initilized";
String s_messageServer = "Not initilized";
String s_messageClient = "Not initilized";

/* Support Functions */

  
/*This function is called when a client disconnects. */
void disconnectEvent(Client myClient){
  /* Make background lighter for each connection event.*/
  myred = constrain( (red(myBackground) -64), 0, 255);  
  mygreen = constrain( (green(myBackground) -64), 0, 255);  
  myblue = constrain( (blue(myBackground) -64), 0, 255);  
  myBackground = color(myred, mygreen, myblue) ;
  s_clientStatus = "Client " + myClient.ip() + " has disconnected";
  appendTextToFile(myLogFileName, ("Client disconnect: " + myClient.ip()));
  s_messageClient = "";
  println("Client disconnect: " + myClient.ip());
//  println("Client event disconnect. Background set to: " + myBackground + " Server Says:  " +myClient.read());
}

// ServerEvent message is generated when a new client connects to an existing server.
  void serverEvent(Server myServer, Client myClient) {
  s_clientAddress = myClient.ip();
  println("\nWe have a new socket client: " + s_clientAddress);
  appendTextToFile(myLogFileName, "Client connected: " + s_clientAddress );
  myred = constrain( (red(myBackground) +64), 0, 255);  
  mygreen = constrain( (green(myBackground) +64), 0, 255);  
  myblue = constrain( (blue(myBackground) +64), 0, 255);  
  myBackground = color(myred, mygreen, myblue) ;
  s_clientStatus = "Client connected: " + s_clientAddress;
}


void setup() 
{
  frameRate(60);  
  background (myBackground);
  size(400, 400); 
//  String startTime = (str(year()) + str(month()) +str(day()) +"_" + str(hour()) + str(minute()) + str(second()) );
  appendTextToFile(myLogFileName, ("Your log is born."));
 
  f = createFont("Arial",6,true);     // Create Font 
  textAlign(RIGHT);                    // Credit will be in lower right corner.
  text("Set up started",400, 10);
  /*Set up server. This coorisponds to sl_Socket which opens a socket, 
  and sl_Bind which is where we set port, 
  and sl_Listen where we start listening.
  */
  myServer = new Server(this, MY_PORT);
  text("Server started",400, 10);  
  if (myServer.active() == true) {
    myBackground = color(0,0,0);
    s_serverStatus = "Server is active.";
  }
}

void draw() 
{
    if (myServer.active() == true) {
    background (myBackground);
    mySocket = " IP: " + Server.ip() + ":" + str(MY_PORT); //<>//
    if (mySocket.equals(myOldSocket) == false) {
      appendTextToFile(myLogFileName, ("Server socket changed from: " + myOldSocket + " to: " + mySocket ));
      println("Server socket changed from: " + myOldSocket + " to: " + mySocket );
      myOldSocket = mySocket;
    }
    text(s_serverStatus + mySocket ,400, 10);
//    text(s_serverStatus + " IP: " + Server.ip() + ":" + str(MY_PORT) ,400, 10);
    text("Client Connection: "+s_clientStatus,400, 20);
    text("Client: " + s_messageClient,400, 40);
    text("Server:" + s_messageServer,400, 50);    

    thisClient = myServer.available();
    // If the client is not null, and says something, display what it said
    if (thisClient !=null) {
      text("Client transmitting",400, 30);
      myClient = thisClient;  // Save off the client object for the key close event.
//      println("myClient is: " + myClient );
      String whatClientSaid = thisClient.readString();
      if (whatClientSaid != null) {
        println(thisClient.ip() + "\t" + whatClientSaid);
        s_messageServer = "";
        s_messageClient = whatClientSaid;
      if (whatClientSaid.startsWith(">04")) {
        String myReply = "#040000000200000000000000000000019000\r\n";
        myServer.write(myReply);
        s_messageServer = myReply;
        s_messageClient = ">04";
        println("Reply with:" + myReply);
      }
      if (whatClientSaid.startsWith(">05")) {
        String myReply = "#05000A\r";
        myServer.write(myReply);
        println("Reply with:" + myReply);
      }// Client sent >05.
      }//Not null from client
    }//Client abailable 

    } else { //Server not aactive
      myBackground = color(255,0,0); //Red to indicate no server.
      background (myBackground);
      s_messageServer = "Server not active";
      s_serverStatus = "Server not active";
      text(s_serverStatus,400, 10);
      text("Client Connection: "+s_clientStatus,400, 20);
      text("Client: " + s_messageClient,400, 40);
      text("Server:" + s_messageServer,400, 50);       
    } 
}//draw()
