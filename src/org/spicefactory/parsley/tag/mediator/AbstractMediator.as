package org.spicefactory.parsley.tag.mediator
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.core.UIComponent;
	
	/**
	 * Abstract Mediator that all Mediators need to extend
	 **/
	public class AbstractMediator extends EventDispatcher
	{
		// Storing view component
		protected var _view:UIComponent; 
		
		/**
		 * Constructor.  
		 * 
		 * @param view The view the mediator is related to; can be null
		 */		
		public function AbstractMediator(view:UIComponent)
		{
			super();
			this._view = view;
		}
		
		/**
		 * Initializing function, can be overridden
		 */		
		[Init]
		public function viewInit():void {}
				
		/**
		 * Destructor function, can be overridden
		 */		
		[Destroy]
		public function viewDestroyed():void
		{
			// TODO: this gets called when 'removeFromStage' happens, do we really want that?
			/*if(this._view)
			{
				// Dispatch remove event
				this._view.dispatchEvent(new Event(Mediator.REMOVE_MEDIATOR, true));
				this._view = null;
			}*/
		}
	}
}