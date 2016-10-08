# Seamcarving

Normal resizing usually results in distorted objects. This project is to allow seamingless resizing for pictures, by calculating the "energy" of each pixel, and find the path where it has least "energy" to be removed. In this case, I'm using derivative of gradient as energy for each pixel. Fore more results: http://inst.eecs.berkeley.edu/~cs194-26/fa16/upload/files/proj4/cs194-26-acm/

# To run code
```
main(<name of image file>, target resulting width, target resulting height)
``` 