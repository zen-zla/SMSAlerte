#!/bin/bash -vx

#*******************************************************************************************#
#                       Script envoie SMS  - zenzla.com   		    	                    #
#             ------------------------------------------------------------  				#
# Ce script permet d'envoyer un SMS à votre téléphone, il fonctionne uniquement 			#
# avec les forfait Free et activé l'oiption dans votre espace client       				#
#*******************************************************************************************#

#*******************************************************************************************#
#         					/!\ ATTENTION SVP  /!\			  								#
#      					 *---------------------------*										#
# 	Ce script est est libre de droit, vous pouvez le modifier, le copier, l’améliorer, 		#	
#	pensez quand même à mettre la source c’est a dire l’URL du site svp. ainsi que 			#
# 	partager l'article sur vos réseaux sociaux. MERCI										#
#																							#
#*******************************************************************************************#.



#
#  Nom de la fonction: parametrage
#  Fonction : Renseignement des paramètres Free Mobile
#  


parametrage(){
#~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*
# Editez ces paramètres suivant
#~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*

LOGIN=""   						# votre identifiant Freemobile
KEY=""           			    # votre clée donnée par freemobile lors de l'activation de cette option, /!\ attention, ce n'est pas votre mot de passe

CURL="$(which curl)"			

verifSiVide
}
#~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*

#
#  Nom de la fonction: verifSiVide
#  Fonction : vérifie si le message est vide
#  
verifSiVide(){
if [ -z "$MESS" ]; then	

	echo "Le message et vide"
	exit 0
	
else
	verif_curl
fi	      			     
}

#
#  Nom de la fonction: verif_curl
#  Fonction : vérifie si "curl" est installer, dans le cas contraire l'instale
#  

verif_curl(){
if [ -z $CURL ]; then                # vérifier si curl est installé

       apt-get install curl
       
       envoi_sms
else
       envoi_sms
fi
}

#
#  Nom de la fonction: envoi_sms
#  Fonction : C'est la fonction qui envois le SMS
#  


envoi_sms() {

curl -i --insecure "https://smsapi.free-mobile.fr/sendmsg?user=$LOGIN&pass=$KEY&msg=$MESS" 2>&1

retour_HTTP=$(echo "$envoi" | awk '/HTTP/ {print $2}')

case $retour_HTTP  in
	200)
		echo "Le message a été envoyé correctement"
		;;
	400)
		echo "le couple expéditeur/mot de passe est erroné, veuillez les vérifier dans le script"
		;;
	402)
		echo "Trop de SMS ont été envoyés en trop peu de temps. Veuillez renouveler ultérieurement"
		;;
	403)
		echo "Le service n’est pas activé sur l’espace abonné. Veuillez l'activer S.V.P"
		;;
	500)
		echo " Erreur côté serveur. Veuillez réessayez ultérieurement."
esac
exit 0
}

# lancement 
if [ ! `id -u` = 0 ]; then  #Nous vérifions que l'utilisateur est root				
	echo "Vous devez être ROOT pour exécuter ce Sript" && exit 0
else
	MESS="$1"
	parametrage
fi
