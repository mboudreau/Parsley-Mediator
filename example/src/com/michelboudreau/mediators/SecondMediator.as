package com.michelboudreau.mediators
{    
    import com.michelboudreau.views.MainUI;
    
    import org.spicefactory.lib.logging.LogContext;
    import org.spicefactory.lib.logging.Logger;
    import org.spicefactory.parsley.tag.mediator.AbstractMediator;
    
	// Specify that this is a Mediator class and which component to listen for
    public class SecondMediator extends AbstractMediator
    {
    	private static const log:Logger = LogContext.getLogger(SecondMediator);     
		
		// Function to easily get casted view component
		protected function get viewComponent():MainUI
		{
			return this._view as MainUI;
		}
		
		public function SecondMediator(view:MainUI = null)
		{
			super(view);
		}
		
		[Init]
		override public function viewInit():void
		{
			if(viewComponent)
			{
				 log.info('{0} Has Been Initialized', SecondMediator);
			}
		}

		
		[Destroy]
		override public function viewDestroyed():void
		{
			if(viewComponent)
			{
				
			}
		}
    }
}
