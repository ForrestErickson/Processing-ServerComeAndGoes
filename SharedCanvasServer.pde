/**
 * Shared Drawing Canvas (Server) 
 * by Alexander R. Galloway. 
 * 
 * A server that shares a drawing canvas between two computers. 
 * In order to open a socket connection, a server must select a 
 * port on which to listen for incoming clients and through which 
 * to communicate. Once the socket is established, a client may 
 * connect to the server and send or receive commands and data.
 * Get this program running and then start the Shared Drawing
 * Canvas (Client) program so see how they interact.
 */

/* Modified by F. Lee Erickson to test out more server features. */
/* 3 June 2019. */

// Rename ServerLaptop.
// Lee Erickson
// 6 June 2019
// First work with Client Example 2 to simulate a ST365 server. 
// Ultimatly to work as a server to a ST365 which is a client.


import processing.net.*;

Server myServer;
Client myClient;
String input;
int data[];
int dataIn; 

/* Support Functions */
/* E for Exit to close*/
void keyPressed() {
  if ((key== 'a'|| (key== 'A'))){
     //Socket Active Test
     println("Testing for active server.");
     if (myServer.active()== true) {
       println("Server active.");  
       } else {
       println("Server not active.");
         }
   }
 if ((key =='s') || (key== 'S')){
     //stop Socket
     println("Stoping socket.");
     myServer.stop();
     println("Stopped socket on keyPressed.");
     //exit();
  }
  
  if ((key== 'd'|| (key== 'D'))){
     //Close Socket
     println("Disconnecting socket.");
     myServer.disconnect(myClient);
     println("Disconnecting socket on keyPressed.");
     exit();
  } 
  
}

 
   
/*This function is called when a client disconnects. */
void disconnectEvent(Client myClient){
  println("Client event disconnect.");
}

// ServerEvent message is generated when a new client connects 
// to an existing server.
  void serverEvent(Server myServer, Client myClient) {
//  void serverEvent(s, c) {
  println("We have a new socket client: " + myClient.ip());
}

//Mouse press to send ST365 command or text.
void mousePressed() {
    if (mouseButton == LEFT){  
    println(">04");
    myClient.write(">04\r");    
    }
    else {
      println(">Hello world");
      myClient.write(">Hello world.\n\r");
    }
} //MousePressed


void setup() 
{
  frameRate(10);  
  background (255,0,0);
  size(200, 200); 
  
  /*Set up server. This coorisponds to sl_Socket which opens a socket, 
  sl_Bind which is where we set port, and
  sl_Listen where we start listening.
  */
  //myServer = new Server(this, 12345); // Start a simple server on a port
  myServer = new Server(this, 23); // Start on Telnet even though we are RAW socket. 
}

void draw() 
{
    if (myServer.active() == true) {
    background (255);
/*
 //   println("Server connected.");
    if (myServer.available() > 0) {
      background (0,0,255);
      dataIn = myClient.read();
      print(char(dataIn));
      //println("Client data recevied; " +stringIn);
    }
*/
  } else { //Server not aactive
    background(0);
    println("Server is not active."); 
  }
 
}//draw()
