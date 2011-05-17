package org.spicefactory.parsley.core.view.impl
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.core.UIComponent;
	
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
	import org.spicefactory.parsley.core.bootstrap.InitializingService;
	import org.spicefactory.parsley.core.context.Context;
	import org.spicefactory.parsley.core.context.DynamicObject;
	import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
	import org.spicefactory.parsley.core.view.ViewAutowireFilter;
	import org.spicefactory.parsley.core.view.ViewManager;
	import org.spicefactory.parsley.core.view.impl.DefaultViewManager;
	import org.spicefactory.parsley.tag.mediator.Mediator;
	
	/**
	 * New view manager specific for the Mediator tag to work.
	 **/
	public class MediatorViewManager implements ViewManager, InitializingService
	{
		private static const log:Logger = LogContext.getLogger(MediatorViewManager);
		// Stores the view-mediator link
		protected var _mediators:Dictionary = new Dictionary(); 
		// Stores the dynamic object after its been created
		protected var _dynamicObjects:Dictionary = new Dictionary();
		protected var _delegate:ViewManager;
		protected var _info:BootstrapInfo;
		
		/**
		 * The new view manager constructor
		 * 
		 * @param delegate The delegate view manager to be used
		 */		
		public function MediatorViewManager(delegate:ViewManager)
		{
			this._delegate = delegate;
		}

		/**
		 * Initialize the view manager with bootstrap info
		 * @param info
		 */		
		public function init(info:BootstrapInfo):void
		{
			this._info = info;
		}
		
		/**
		 * Add the view root to the view manager, listen for events
		 *  
		 * @param view The display object the context is linked to
		 */		
		public function addViewRoot(view:DisplayObject):void
		{
			this._delegate.addViewRoot(view);
			view.addEventListener(Mediator.WIRE_MEDIATOR, onWireMediator);
		}
		
		/**
		 * Remove the view root from the view manager, remove event listeners
		 *  
		 * @param view The display object the context is linked to
		 */
		public function removeViewRoot(view:DisplayObject):void
		{
			this._delegate.removeViewRoot(view);
			view.removeEventListener(Mediator.WIRE_MEDIATOR, onWireMediator);
			view.removeEventListener(Mediator.REMOVE_MEDIATOR, onRemoveMediator);
		}
		
		/**
		 * Adds a relationship between the view and the mediator class
		 *  
		 * @param view The view class to relate the mediator to
		 * @param mediator The object definition of the mediator
		 */		
		public function addMediator(view:Class, mediator:DynamicObjectDefinition):void
		{
			// Can only add one mediator per view
			if(this._mediators[view] == null)
			{
				log.debug("Adding mediator link: '{0}' for '{1}'", mediator.type.name, getQualifiedClassName(view));
				this._mediators[view] = mediator;
			}
		}
		
		/**
		 * Handler for the WIRE_MEDIATOR event.  It creates the mediator associated with the 
		 * target and assigns the view to it.
		 * 
		 * @param e The event for wire mediator.
		 */		
		protected function onWireMediator(e:Event):void
		{
			var view:DisplayObject = e.target as DisplayObject;
			if(view)
			{
				var classInfo:ClassInfo = ClassInfo.forInstance(view, this._info.domain); // Get class info
				var mediator:DynamicObjectDefinition = this._mediators[classInfo.getClass()]; // Check if mediator class exists
				if(mediator)
				{
					// Retreive Mediator Class
					var mediatorClass:Class = mediator.type.getClass();
					log.debug("Creating Mediator '{0}'", mediator.type.name);
					// Create dynamic object for Mediator, inject view into Mediator
					this._dynamicObjects[view] = this._info.context.addDynamicObject(new mediatorClass(view));
					// Listen for when the view gets destroyed
					// TODO: test destruction
					view.addEventListener(Mediator.REMOVE_MEDIATOR, onRemoveMediator);
				}else{
					log.debug("There are no Mediators related to '{0}'", view);
				}
			}
		}
		
		/**
		 * Handler for removing the mediator. WIP
		 * @param e
		 */		
		protected function onRemoveMediator(e:Event):void
		{
			var view:DisplayObject = e.target as DisplayObject;
			if(view)
			{
				view.removeEventListener(Mediator.REMOVE_MEDIATOR, onRemoveMediator);
				var mediatorObject:DynamicObject = this._dynamicObjects[view];
				if(mediatorObject)
				{
					log.debug("Removing Mediator from '{0}'", view);
					this._dynamicObjects[view] = null;
					delete this._dynamicObjects[view];
					mediatorObject.remove();
				}
			}
		}
	}
}