# Marvel-Heroes
An iOS App to display Marvel heroes from Marvel API

# Dependencies
This project uses couple of dependencies. Those are: Realm, Kingfisher.

# Installation
1 - In order to build the project successfully, the dependencies included in the dependencies section should be installed first.

2 - To download the dependencies, Cocoapods should be used. If you are new to Cocoapods you may get more information on: https://cocoapods.org

3 - Since the podfile is already included in the repository, all you need to do use related pods, is to run `pod install` in the project directory.

* Normally, To install the pods, create a new Podfile with `pod init` in the related project directory and add following lines below `# Pods for Marvel Heroes`
```
pod 'Kingfisher'
pod 'RealmSwift'
```
More details on how to install a pod can be found on `Get Started` section here: https://cocoapods.org

4 - Replace the dummy text of your public key and private key with your app's in MarvelAPI.swift file.
* Keys can be generated at https://developer.marvel.com

5 - Deploy it to your device or run it on the simulator!
