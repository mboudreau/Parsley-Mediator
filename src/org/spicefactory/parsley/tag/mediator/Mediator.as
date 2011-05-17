package org.spicefactory.parsley.tag.mediator
{
	import org.spicefactory.lib.logging.LogContext;
	import org.spicefactory.lib.logging.Logger;
	import org.spicefactory.lib.reflect.Metadata;
	import org.spicefactory.parsley.config.ObjectDefinitionDecorator;
	import org.spicefactory.parsley.core.bootstrap.BootstrapDefaults;
	import org.spicefactory.parsley.core.errors.ContextError;
	import org.spicefactory.parsley.core.factory.ViewManagerFactory;
	import org.spicefactory.parsley.core.factory.impl.GlobalFactoryRegistry;
	import org.spicefactory.parsley.core.view.impl.MediatorViewManager;
	import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
	
	/**
	 * Mediator decorator for extending Parsley. 
	 */	
	[Metadata(types="class")]
	public class Mediator implements ObjectDefinitionDecorator
	{
		// Class logger
		private static const log:Logger = LogContext.getLogger(Mediator);
		
		// Mediator Events
		public static const WIRE_MEDIATOR:String = 'wireMediator';
		public static const REMOVE_MEDIATOR:String = 'removeMediator';
		
		// This gets injected automatically by Parsley when the tag is specified
		public var view:Class;
		
		/**
		 * Decorate function gets called automatically by the Parsley extension framework
		 * when the tag 'runs'
		 * 
		 * @param definition An object definition of the class that use the Mediator tag
		 */		
		public function decorate (definition:ObjectDefinitionBuilder):void 
		{
			// Check if view exists
			if(!view)
			{
				throw new ContextError("You must specify a 'view' for which the Mediator must listen for.");
			}
			
			// Make sure the Mediator extends AbstractMediator
			if(definition.typeInfo.isType(AbstractMediator))
			{
				var viewManager:MediatorViewManager = definition.config.context.viewManager as MediatorViewManager;
				if(viewManager)
				{
					// Store the view-mediator relationship in the extended View Manager
					viewManager.addMediator(view, definition.asDynamicObject().build());
				}else{
					throw new ContextError("Cannot use [Mediator] metatags without MediatorViewManager");
				}
			}else{
				throw new ContextError("You must specify a 'view' for which the Mediator must listen for.");
			}
		}
		
		/**
		 * Initializes the Mediator and replaces the default view manager with 
		 * the Mediator's view manager.
		 */		
		public static function initialize():void
		{
			// Register the metadata
			Metadata.registerMetadataClass(Mediator);
			// replace view manager
			BootstrapDefaults.config.services.viewManager.addDecorator(MediatorViewManager);
		}
	}
}