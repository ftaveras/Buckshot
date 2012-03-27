class FrameworkAnimationTests extends TestGroupBase {
  
  void registerTests(){
    this.testGroupName = "FrameworkAnimation Tests";
    
    testList["set property transition"] = setPropertyTransition;
    testList["remove property transition"] = removePropertyTransition;
    }

  void setPropertyTransition(){
    Border b = new Border();
    
    //create a transition entry
    FrameworkAnimation.setPropertyTransition(b.backgroundProperty, new PropertyTransition(1, TransitionTiming.linear));
    
    Expect.equals('background 1s linear 0s', Dom.getXPCSS(b._component, 'transition'));
    
    
    //add another one
    FrameworkAnimation.setPropertyTransition(b.borderColorProperty, new PropertyTransition(1, TransitionTiming.linear));
    
    Expect.equals('background 1s linear 0s, border-color 1s linear 0s', Dom.getXPCSS(b._component, 'transition'));
    
    
    //replace value    
    FrameworkAnimation.setPropertyTransition(b.backgroundProperty, new PropertyTransition(3, TransitionTiming.easeIn));
    
    Expect.equals('background 3s ease-in 0s, border-color 1s linear 0s', Dom.getXPCSS(b._component, 'transition'));
  }
  
  void removePropertyTransition(){
    Border b = new Border();
    
    //create a transition entry
    FrameworkAnimation.setPropertyTransition(b.backgroundProperty, new PropertyTransition(1, TransitionTiming.linear));
    
    //add another one
    FrameworkAnimation.setPropertyTransition(b.borderColorProperty, new PropertyTransition(1, TransitionTiming.linear));     
    
    //remove and test
    FrameworkAnimation.clearPropertyTransition(b.backgroundProperty);
    
    Expect.equals('border-color 1s linear 0s', Dom.getXPCSS(b._component, 'transition'));
    
    FrameworkAnimation.clearPropertyTransition(b.borderColorProperty);
    
    Expect.isNull(Dom.getXPCSS(b._component, 'transition'));
    
  }
}