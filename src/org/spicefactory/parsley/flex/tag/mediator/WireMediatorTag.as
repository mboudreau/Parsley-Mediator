package org.spicefactory.parsley.flex.tag.mediator
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import org.spicefactory.parsley.flex.tag.ConfigurationTagBase;
	import org.spicefactory.parsley.tag.mediator.Mediator;
	
	/**
	 * Quick class made to dispatch the wireMediator event
	 * instead of doing it manually.
	 **/
	public class WireMediatorTag extends ConfigurationTagBase
	{
		public function WireMediatorTag()
		{
			super();
		}
		
		override protected function executeAction(view:DisplayObject):void
		{
			view.dispatchEvent(new Event(Mediator.WIRE_MEDIATOR, true));
		}
	}
}