package org.spicefactory.parsley.flex.tag.mediator
{
	import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
	import org.spicefactory.parsley.flex.tag.builder.BootstrapConfigProcessor;
	import org.spicefactory.parsley.tag.mediator.Mediator;
	
	public class MediatorTag implements BootstrapConfigProcessor
	{		
		public function processConfig(config:BootstrapConfig):void
		{
			Mediator.initialize();
		}
	}
}