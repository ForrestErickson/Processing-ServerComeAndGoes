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

import processing.net.*;

Server s;
Client c;
String input;
int data[];

/* Support Functions */
/* E for Exit to close*/
void keyPressed() {
  if ((key== 'a'|| (key== 'A'))){
     //Socket Active Test
     println("Testing for active server.");
     if (s.active()== true) {
       println("Server active.");  
       } else {
       println("Server not active.");
         }
   }
 if ((key =='s') || (key== 'S')){
     //stop Socket
     println("Stoping socket.");
     s.stop();
     println("Stopped socket on keyPressed.");
     //exit();
  }
  
  if ((key== 'e'|| (key== 'E'))){
     //Close Socket
     println("Disconnecting socket.");
     s.disconnect(c);
     println("Exiting socket on keyPressed.");
     exit();
  } 
  
}

 
   
/*This function is called when a client disconnects. */
void disconnectEvent(Client c){
  println("Client has disconnected");
}

// ServerEvent message is generated when a new client connects 
// to an existing server.
  void serverEvent(Server s, Client c) {
//  void serverEvent(s, c) {
  println("We have a new client: " + c.ip());
}


/* Right Mouse Drop Client */
void mousePressed(){
   if (mouseButton == RIGHT) {
    //s.write("You will be disconnected now.rn");
    println(s.ip() + " to be disconnected");
//    s.disconnect(c);
    s.disconnect(c);
    println(s.ip() + " has been disconnected");
   }  
} //MousePressed


void setup() 
{
  size(450, 255);
  background(204);
  stroke(0);
  frameRate(5); // Slow it down a little
  s = new Server(this, 12345); // Start a simple server on a port
}

void draw() 
{
  if (mousePressed == true) {
    // Draw our line
    stroke(255);
    line(pmouseX, pmouseY, mouseX, mouseY);
    // Send mouse coords to other person
    if (s.active() == true){
      s.write(pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
    }
  }
  // Receive data from client
  c = s.available();    //Get available client.
  if (c != null) {
    input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = int(split(input, ' ')); // Split values into an array
    // Draw line using received coords
    stroke(0);
    line(data[0], data[1], data[2], data[3]);
  }
}
