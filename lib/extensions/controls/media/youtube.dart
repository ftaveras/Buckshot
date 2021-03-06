// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('youtube.media.controls.buckshotui.org');
#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dart_utils/web.dart');

class YouTube extends FrameworkElement
{
  FrameworkProperty videoIDProperty;

  YouTube(){
    Browser.appendClass(rawElement, "youtube");

    _initializeYouTubeProperties();
  }

  YouTube.register() : super.register();
  makeMe() => new YouTube();


  void _initializeYouTubeProperties(){
    videoIDProperty = new FrameworkProperty(this, "videoID", (String value){
      rawElement.attributes["src"] = 'http://www.youtube.com/embed/${value.toString()}?wmode=transparent';
    });
  }

  String get videoID => getValue(videoIDProperty);
  set videoID(String value) => setValue(videoIDProperty, value);


  void createElement(){
    rawElement = new Element.tag("iframe");
    Browser.appendClass(rawElement, 'youtube-player');
    rawElement.attributes["type"] = "text/html";
    rawElement.attributes["frameborder"] = "0";
  }
}
