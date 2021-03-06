// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

/**
 * Alias element for [StackPanel].  Provides a shortened name in templates.
 */
class Stack extends StackPanel {
  Stack() : super();
  Stack.register() : super.register();
  makeMe() => new StackPanel();
}

/**
* Provides a container that stacks child elements vertically or horizontally. */
class StackPanel extends Panel
{
  FrameworkProperty orientationProperty;

  StackPanel()
  {
    Browser.appendClass(rawElement, "stackpanel");

    initStackPanelProperties();
  }
  
  StackPanel.register() : super.register();
  makeMe() => new StackPanel();

  void initStackPanelProperties(){
    orientationProperty = new FrameworkProperty(
      this,
      "orientation",
      (Orientation value){
        Polly.setFlexBoxOrientation(this, value);
      },
      Orientation.vertical, converter:const StringToOrientationConverter());
  }

  void onChildrenChanging(ListChangedEventArgs args){
    super.onChildrenChanging(args);

    if (!args.oldItems.isEmpty()){
      args.oldItems.forEach((FrameworkElement element){
        element.removeFromLayoutTree();
      });
    }

    if (!args.newItems.isEmpty()){
      args.newItems.forEach((FrameworkElement element){

        element.addToLayoutTree(this);
        if (Polly._flexModel == FlexModel.Manual){
          Polly.setManualMultiStackOrientation(element, orientation);
        }
      });
    }
  }

  set orientation(Orientation value) => setValue(orientationProperty, value);
  Orientation get orientation => getValue(orientationProperty);

  void createElement(){
    rawElement = new DivElement();
    Polly.makeFlexBox(rawElement, ManualFlexType.Multi);
    //rawElement.style.flexFlow = 'column';
    rawElement.style.overflow = 'hidden';

    Polly.setVerticalFlexBoxAlignment(this, VerticalAlignment.top);
    Polly.setHorizontalFlexBoxAlignment(this, HorizontalAlignment.left);
  }

  void updateLayout(){
    // set alignment of children along the cross access
    if (orientation == Orientation.vertical){
      children.forEach((FrameworkElement child){
        Polly.setItemHorizontalCrossAxisAlignment(child, child.hAlign);
      });
    }else{
      children.forEach((child){
        Polly.setItemVerticalCrossAxisAlignment(child, child.vAlign);
      });
    }
  }
}
