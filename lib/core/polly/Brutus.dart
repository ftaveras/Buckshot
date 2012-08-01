// Copyright (c) 2012, John Evans
// http://www.buckshotui.org
// See LICENSE file for Apache 2.0 licensing information.


/**
 * Support class for [Polly] that tracks an manages manual alignments for a
 * [FrameworkElement] within a parent container.
 */
class Brutus
{
  EventHandlerReference _eventReference;
  var _preservedWidth;
  var _preservedHeight;
  var _preservedLeftMargin;
  var _preservedTopMargin;

  final FrameworkElement element;

  HorizontalAlignment manualHorizontalAlignment;
  VerticalAlignment manualVerticalAlignment;

  Brutus.with(this.element);


  /**
   * Enables given manual vertical [alignment] of element within it's parent
   * container.
   */
  void enableManualVerticalAlignment(VerticalAlignment alignment){

    if (manualVerticalAlignment != null && manualVerticalAlignment == alignment){
      return;
    }

    if (manualVerticalAlignment != null){
      disableManualVerticalAlignment();
    }

    if (alignment == VerticalAlignment.top) return;

    manualVerticalAlignment = alignment;

    void handleVerticalStretch(){
      //save the width value for later restoral
      _preservedHeight = element.rawElement.style.height;
    }

    void handleVerticalCenter(){
      _preservedTopMargin = element.margin;
    }

    void handleVerticalBottom(){
      _preservedTopMargin = element.margin;
    }

    switch(alignment){
      case VerticalAlignment.stretch:
        handleVerticalStretch();
        break;
      case VerticalAlignment.center:
        handleVerticalCenter();
        break;
      case VerticalAlignment.bottom:
        handleVerticalBottom();
        break;
    }

    _subscribeMeasurementChanged();
  }

  disableManualVerticalAlignment(){
    if (manualVerticalAlignment == null) return;

    if (manualHorizontalAlignment == null){
      _unsubscribeMeasurementChanged();
    }

    void handleVerticalStretch(){

      element.rawElement.style.height = _preservedHeight;

      _preservedHeight = null;
    }

    void handleVerticalCenter(){
      element.margin = _preservedTopMargin;

      _preservedTopMargin = null;
    }

    void handleVerticalBottom(){
      element.margin = _preservedTopMargin;

      _preservedTopMargin = null;
    }

    switch(manualVerticalAlignment){
      case VerticalAlignment.stretch:
        handleVerticalStretch();
        break;
      case VerticalAlignment.top:
        return;
      case VerticalAlignment.center:
        handleVerticalCenter();
        break;
      case VerticalAlignment.bottom:
        handleVerticalBottom();
        break;
    }

    manualVerticalAlignment = null;
  }

  /**
   * Enables given manual horizontal [alignment] of element within it's parent
   * container.
   */
  void enableManualHorizontalAlignment(HorizontalAlignment alignment){

    if (manualHorizontalAlignment != null &&
        manualHorizontalAlignment == alignment){
      return;
    }

    if (manualHorizontalAlignment != null){
      disableManualHorizontalAlignment();
    }

    if (alignment == HorizontalAlignment.left) return;

//    db('enable manual horizontal alignment', element);

    manualHorizontalAlignment = alignment;

    void handleHorizontalStretch(){
      //save the width value for later restoral
      _preservedWidth = element.rawElement.style.width;
    }

    void handleHorizontalCenter(){
      _preservedLeftMargin = element.margin;
    }

    void handleHorizontalRight(){
      _preservedLeftMargin = element.margin;
    }

    switch(alignment){
      case HorizontalAlignment.stretch:
        handleHorizontalStretch();
        break;
      case HorizontalAlignment.center:
        handleHorizontalCenter();
        break;
      case HorizontalAlignment.right:
        handleHorizontalRight();
        break;
    }

    _subscribeMeasurementChanged();
  }

  void disableManualHorizontalAlignment(){

    if (manualHorizontalAlignment == null) return;

    if (manualVerticalAlignment == null){
      _unsubscribeMeasurementChanged();
    }

    void handleHorizontalStretch(){

      element.rawElement.style.width = _preservedWidth;

      _preservedWidth = null;
    }

    void handleHorizontalCenter(){
      element.margin = _preservedLeftMargin;

      _preservedLeftMargin = null;
    }

    void handleHorizontalRight(){
      element.margin = _preservedLeftMargin;

      _preservedLeftMargin = null;
    }

    switch(manualHorizontalAlignment){
      case HorizontalAlignment.stretch:
        handleHorizontalStretch();
        break;
      case HorizontalAlignment.left:
        return;
      case HorizontalAlignment.center:
        handleHorizontalCenter();
        break;
      case HorizontalAlignment.right:
        handleHorizontalRight();
        break;
    }

    manualHorizontalAlignment = null;
  }

  void clearAllManualAlignments(){
    disableManualHorizontalAlignment();
    disableManualVerticalAlignment();
  }

  void _subscribeMeasurementChanged(){
    if (_eventReference != null) return;

    //assign event handler reference to statebag
    _eventReference =
        element.parent.measurementChanged + _sizeChangedEventHandler;

  }

  void _unsubscribeMeasurementChanged(){
    if (_eventReference == null) return;

    element.parent.measurementChanged - _eventReference;

    _eventReference = null;
  }
  void _sizeChangedEventHandler(_, MeasurementChangedEventArgs args){
    var newTop = 0;
    var newLeft = 0;

    void handleHorizontalStretch(){
      if (element.hasProperty('padding')){
        final calcWidth = args.newMeasurement.client.width -
            (element.dynamic.padding.left +
             element.dynamic.padding.right +
             element.margin.left +
             element.margin.right +
             ((element.parent.hasProperty('padding'))
              ? element.parent.dynamic.padding.left +
                  element.parent.dynamic.padding.right
              : 0));
        element.rawElement.style.width = '${calcWidth}px';
      }else{
        final calcWidth = args.newMeasurement.client.width -
            (element.margin.left + element.margin.right +
             ((element.parent.hasProperty('padding'))
              ? element.parent.dynamic.padding.left +
                  element.parent.dynamic.padding.right
              : 0));
        element.rawElement.style.width = '${calcWidth}px';
      }
    }

    void handleHorizontalCenter(ElementRect r){
      newLeft =
          (args.newMeasurement.client.width / 2) - (r.bounding.width / 2);
    }

    void handleHorizontalRight(ElementRect r){
      newLeft = args.newMeasurement.client.width - r.client.width;
//        db('parent width:${args.newMeasurement.client.width}, element width: ${r.client.width}, $position', element);

    }

    void handleVerticalStretch(){
      if (element.hasProperty('padding')){
        final calcHeight = args.newMeasurement.client.height -
            (element.dynamic.padding.top +
             element.dynamic.padding.bottom +
             element.margin.top +
             element.margin.bottom +
             ((element.parent.hasProperty('padding'))
              ? element.parent.dynamic.padding.top +
                  element.parent.dynamic.padding.bottom
              : 0));
        element.rawElement.style.height = '${calcHeight}px';
      }else{
        final calcHeight = args.newMeasurement.client.height -
            (element.margin.top + element.margin.bottom +
             ((element.parent.hasProperty('padding'))
              ? element.parent.dynamic.padding.top +
                  element.parent.dynamic.padding.bottom
              : 0));
        element.rawElement.style.height = '${calcHeight}px';
      }
    }

    void handleVerticalCenter(ElementRect r){
      newTop = (args.newMeasurement.client.height / 2) - (r.client.height / 2);

     // db('*** vertical center parent height:${args.newMeasurement.client.height}, element height: ${r.client.height}, $position', element);
    }

    void handleVerticalBottom(ElementRect r){
      newTop = args.newMeasurement.client.height - r.client.height;
    }

    element
    .updateMeasurementAsync
    .then((ElementRect r){

      if(manualHorizontalAlignment != null){
        switch(manualHorizontalAlignment){
          case HorizontalAlignment.stretch:
            handleHorizontalStretch();
            break;
          case HorizontalAlignment.center:
            handleHorizontalCenter(r);
            break;
          case HorizontalAlignment.right:
            handleHorizontalRight(r);
            break;
          default:
            print('Brutus: Invalid alignment.');
            break;
        }
      }

      if (manualVerticalAlignment != null){
        switch(manualVerticalAlignment){
          case VerticalAlignment.stretch:
            handleVerticalStretch();
            break;
          case VerticalAlignment.center:
            handleVerticalCenter(r);
            break;
          case VerticalAlignment.bottom:
            handleVerticalBottom(r);
            break;
          default:
            print('Brutus: Invalid alignment.');
            break;
        }
      }

     if (_preservedLeftMargin != null){
//       db('${newTop + _preservedLeftMargin.top}px'
//          ' ${_preservedLeftMargin.right}px'
//          ' ${_preservedLeftMargin.bottom}px'
//          ' ${newLeft + _preservedLeftMargin.left}px',element);

          element.rawElement.style.margin =
              '${newTop + _preservedLeftMargin.top}px'
              ' ${_preservedLeftMargin.right}px'
              ' ${_preservedLeftMargin.bottom}px'
              ' ${newLeft + _preservedLeftMargin.left}px';
      }else if (_preservedTopMargin != null){
//        db('${newTop + _preservedTopMargin.top}px'
//        ' ${_preservedTopMargin.right}px'
//        ' ${_preservedTopMargin.bottom}px'
//        ' ${newLeft + _preservedTopMargin.left}px',element);

        element.rawElement.style.margin =
            '${newTop + _preservedTopMargin.top}px'
            ' ${_preservedTopMargin.right}px'
            ' ${_preservedTopMargin.bottom}px'
            ' ${newLeft + _preservedTopMargin.left}px';
      }
    });
  }
}
