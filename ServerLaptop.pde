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
public static Client myClient;
String input;
int data[];
int dataIn; 

int myBackground = 0;

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
     //Close Socket  ???thisClient???   
//     thisClient = myServer.available();
//     println("Disconnecting socket. Server: " + myServer + ", Client: " + thisClient);     
     Client myClient = myServer.available();
     println("Disconnecting socket. Server: " + myServer + ", Client: " + myClient);
/*     
     if (myClient != null){
       myServer.disconnect(myClient);
     }
*/

      try{
         //do something that might throw NPE
         myServer.disconnect(myClient);
      }
      catch(NullPointerException npe){
         //uh oh, an NPE happened
         println("I got a null pointer all right.");
      }


     println("Disconnecting socket on keyPressed.");
     //exit();
  } 
  
}

 
   
/*This function is called when a client disconnects. */
void disconnectEvent(Client myClient){
  println("\nWe have a socket disconnect.");
//  myServer.disconnect(myClient);
   print("Server Says:  ");  
  println(myClient.read());
  myBackground = constrain( (myBackground-64), 0, 255) ;  
  println("Client event disconnect. Background set to: " + myBackground);
}

// ServerEvent message is generated when a new client connects 
// to an existing server.
  void serverEvent(Server myServer, Client myClient) {
//  void serverEvent(s, c) {
  println("\nWe have a new socket client: " + myClient.ip());
  myBackground = constrain( (myBackground+64), 0, 255) ;  
  println("Client event connect. Background set to: " + myBackground);
}

//Mouse press to send ST365 command or text.
void mousePressed() {
  if (myServer.active() == true){  
    if (mouseButton == LEFT){  
    println(">04");
    myServer.write(">04\r");    
    }
    else {
      println(">Hello world");
      myServer.write(">Hello world.\n\r");
    }
  }//Active
  else{
  }
  
} //MousePressed


void setup() 
{
  frameRate(10);  
  background (myBackground);
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
    background (myBackground);
/*
 //   println("Server connected.");
    if (myServer.available() > 0) {
      background (0,0,255);
      dataIn = myClient.read();
      print(char(dataIn));
      //println("Client data recevied; " +stringIn);
    }
*/
    Client thisClient = myServer.available();
    // If the client is not null, and says something, display what it said
    if (thisClient !=null) {
      String whatClientSaid = thisClient.readString();
      if (whatClientSaid != null) {
        println(thisClient.ip() + "\t" + whatClientSaid);
      if (whatClientSaid.startsWith(">04")) {
//        String myReply = "#04 Hello world. From Server.\n\r";
        String myReply = "#040000000200000000000000000000019000\r";
        myServer.write(myReply);
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
    //println("Server is not active."); 
  }
 
}//draw()
