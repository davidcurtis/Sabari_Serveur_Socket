import'dart:io';
import'dart:json';


class SabariServeur {
  ServerSocket serveurALecoute;
  List listSocket;
  List <String> nomUtilisateurs = new List<String>();
  String commande;
  
  
  SabariServeur() {
    listSocket = new List();
    
    //------------------------------------------- Changez l'adresse IP du serveur en mettant votre addresse à la place --------------
    serveurALecoute = new ServerSocket("", 8080, 0);
    //-------------------------------------------------------------------------------------------------------------------------------
    
    serveurALecoute.onConnection = this.nouvelleConnection;
  }
  
  void arretServeur() {
    List cls = "** Le Serveur a recue une requête d'arrêt du client **\n".charCodes;
    
    while(!listSocket.isEmpty) {
      Socket conn = listSocket.removeLast();
      conn.writeList(cls, 0, cls.length);
      conn.close();
    }
  }
  
  void nouvelleConnection(Socket socketClient) {

    listSocket.add(socketClient);
    print(listSocket.length);
    StringInputStream entreeClient = new StringInputStream(socketClient.inputStream);
    
    entreeClient.onLine = () {
      
      String entre = entreeClient.readLine();
      print("Message recue: $entre");
      List<String> listeRecue = entre.split(',');
      
      
      if(entre.toLowerCase() == 'stop') {
        arretServeur();
        serveurALecoute.close();
        print("**Arrêt du serveur ! **");
      } 
      
      // Message groupé
      else if( listeRecue.contains('msgAll')) 
      {
        listSocket.forEach((Socket d)
            {
                String outpoutListe = "msgAll,".concat(listeRecue[1].toString().concat(listeRecue[2].toString().concat('\n'))) ;
                 d.writeList(outpoutListe.charCodes, 0, outpoutListe.length);
                 print(d.toString());
                     
            }); 
      }
      //Enregistrement 
      else if( listeRecue.contains('register'))
      {
        String nom = listeRecue.last.toString();
     
         nomUtilisateurs.add(nom);
         print("Membre enregistre ${nomUtilisateurs.toString()}");
         
         listSocket.forEach((Socket d)
             {
           nomUtilisateurs.forEach((String nom) 
               {
                  String outpoutListe = "list,".concat(nom.concat('\n')) ;
                 d.writeList(outpoutListe.charCodes, 0, outpoutListe.length);
                 print(d.toString());
               });
             
        });    
        
      } 
      
    };
    
    
  }
  


}


void main() {

  print("==================++ Bienvenue sur Sabari Chat ! ++=====================\n");
  print("Bienvenue sur Sabari Chat !\n");
  
  SabariServeur sab = new SabariServeur();
  
}


 

