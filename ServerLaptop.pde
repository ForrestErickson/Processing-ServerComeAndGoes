/** ServerLaptop
 *
 * /authorF. Lee Erickson.  
 * /brief Modified by, to indicate server status and trafic with client.
 *
 * 3 June 2019. 
 * Transmongrafied from "Shared Drawing Canvas" (Server) Example by Alexander R. Galloway. 
 */

// 6 June 2019
// First work with Client Example 2 to simulate a ST365 server. 
// Ultimatly to work as a server to a ST365 which is a client.
// 7 June 2019 Server opens up on port 23 and once a client connects indicates in draw window. 
// Client data printed to console.  Mouse sends some data to client.
// The client must receive at least one character before it can disconnect with out exception.
// 11 June Connected with CC3220SocketFunction success.
// Add text into window for status and messages.

import processing.net.*;

Server myServer;
Client myClient;
Client thisClient;
//int MY_PORT = 23; // Start on Telnet even though we are RAW socket.
int MY_PORT = 5001; // Start on P2P port used by Android.

PFont f;                          // Declare PFont variable

String input;
int data[];
int dataIn;

int myBackground = 0;
String s_clientStatus = "Not initilized";
String s_messageServer = "Not initilized";
String s_messageClient = "Not initilized";

/* Support Functions */

/* User Interface with keyboard*/
void keyPressed() {
  //Proccess keys of UI.
  
  if ((key== 'a'|| (key== 'A'))){
     //Socket Active Test
     println("Testing for active server.");
     if (myServer.active()== true) {
       println("Server active.");  
       } else {
       println("Server not active.");
         }
   }// A
 
  if ((key== 'd'|| (key== 'D'))){
     //Disconnect Client Socket  ???thisClient???   
     println("Disconnecting Client socket. Server: " + myServer + ", Client: " + myClient);
     try{
        //do something that might throw NPE
        myServer.disconnect(myClient);
        println("I did it. I got a Non null pointer and disconnected that client.");
     }
     catch(NullPointerException npe){
        //uh oh, an NPE happened
        println("Client disconnect exception, I got a null pointer all right.");
     } //disconnect client();
  }//D
  
    if ((key== 'e'|| (key== 'E'))){
     //Stop Clients, Server and then Exit this program     
     try {
       myServer.disconnect(myClient);
       println("Client disconnect.");
     } catch (Exception npe)
     {
       println("Clien Disconnect exception with: " + npe);
     }
     try {
       myServer.stop();
       println("Server Stop");
     } catch (Exception npe) 
       {
       println("Server Stop exception with: " + npe);
       }
     println("Good buy.");
     exit();
   }// E
  
  if ((key =='s') || (key== 'S')){
     //stop Socket
     println("Stoping Server.");
     myServer.stop();
     println("Stopped Server on keyPressed.");
     //exit();
  }//S  
}// User Interface keyPressed() 
   
/*This function is called when a client disconnects. */
void disconnectEvent(Client myClient){
  //println("\nWe have a client socket disconnect event.");
  //println("Server Says:  " +myClient.read());  
  myBackground = constrain( (myBackground-64), 0, 255) ;  
  s_clientStatus = "Client disconnected";
  s_messageServer = "";
  s_messageClient = "";
  println("Client event disconnect. Background set to: " + myBackground + " Server Says:  " +myClient.read());
}

// ServerEvent message is generated when a new client connects 
// to an existing server.
  void serverEvent(Server myServer, Client myClient) {
//  void serverEvent(s, c) {
  println("\nWe have a new socket client: " + myClient.ip());
  myBackground = constrain( (myBackground+64), 0, 255) ;
  s_clientStatus = "Client connected";
  println("Client event connect. Background set to: " + myBackground);
}

//Mouse press to send ST365 command or text.
void mousePressed() {
  if (myServer.active() == true){  
    if (mouseButton == LEFT){  
    println(">04");
    myServer.write(">04\r");    
    s_messageServer = ">04\r";
    s_messageClient = "";
    }
    else {
      println(">Hello world");
      myServer.write(">Hello world.\n\r");
      s_messageServer = ">Hello world.\n\r";
      s_messageClient = "";
    }
  }//Active
  else{
  }
  
} //MousePressed


void setup() 
{
  frameRate(60);  
  background (myBackground);
  size(400, 200); 
 
  f = createFont("Arial",6,true);     // Create Font 
  textAlign(RIGHT);                    // Credit will be in lower right corner.
  /*Set up server. This coorisponds to sl_Socket which opens a socket, 
  sl_Bind which is where we set port, and
  sl_Listen where we start listening.
  */
  //myServer = new Server(this, 12345); // Start a simple server on a port
  myServer = new Server(this, MY_PORT);  
}

void draw() 
{
    if (myServer.active() == true) {
    background (myBackground);
    text("Server connected",400, 10);
    text(s_clientStatus,400, 20);
    text("Server:" + s_messageServer,400, 40);
    text("Client: " + s_messageClient,400, 50);
    

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
//        String myReply = "#04 Hello world. From Server.\n\r";
        String myReply = "#040000000200000000000000000000019000\r";
        myServer.write(myReply);
        s_messageServer = myReply;
        s_messageClient = ">04";
        println("Reply with:" + myReply);
      }
      if (whatClientSaid.startsWith(">05")) {
        String myReply = "#05000A\r";
//        String myReply = "#05 Good buy cold crule world. From Server.\n\r";
        myServer.write(myReply);
        println("Reply with:" + myReply);
      }
      }//Not null from client
  }//Client abailable 

  } 
  else { //Server not aactive
    background(255,0,0); //Red to indicate no server.
    text("Server not active",100, 100);
    //println("Server is not active."); 
  }
 
}//draw()
