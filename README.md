# ProjectBlackjack
Blackjack w/ gui and potentially more AI players
498V Project Idea- Filip Laestadius PJ Wise

Goals:
  * Find and import useable gui library
  * Write a blackjack AI
  * Make our own artwork (potentially)

Progress:
  * Built a template project using hsqml for the GUI (http://www.gekkou.co.uk/software/hsqml/)

Installation: 
  1. Make sure you have GHC >= 7.4 and a c++ compiler
  2. Install Qt >= 5.0
     On debian you may need to install qt5-make, qtdeclarative5-dev, qtquick1-5-dev, and qml-module-qtquick-controls
  3. cd into root of project
  4. 'cabal sandbox init'
  5. 'cabal install --dependencies-only'
  6. 'cabal build'
  7. 'cabal run'

