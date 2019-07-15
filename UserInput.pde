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


/** Mouse functions 
 *
 * /brief Send server messages through socket. 
 * The ST365 Status quiry on left and Hello world on right. 
 */

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
      myServer.write(">Hello from server.\n\r");
      s_messageServer = ">Hello from server.\n\r";
      s_messageClient = "";
    }
  }//Active
  else{
  }
  
} //MousePressed
