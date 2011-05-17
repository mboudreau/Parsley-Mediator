package com.michelboudreau.utils
{
	import flash.external.ExternalInterface;
	
	import mx.formatters.DateFormatter;
	import mx.logging.ILogger;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;

	public class FirebugLoggerTarget extends TraceTarget
	{
		private var _dateFormatter:DateFormatter = new DateFormatter();
		
		public function FirebugLoggerTarget()
		{
			super();
		}
		
		/**
		 * Overrides the main function of TraceTarget that gets triggered
		 * every time someone tries to log anything using a Logger
		 **/
		override public function logEvent(event:LogEvent):void
		{
			// send the event to be traced normally
			super.logEvent(event); 
			// Find the level
			var levelType:String = getLevelString(event.level);
			var level:String = includeLevel?levelType.toUpperCase():'';
			
			// Date variables
			var date:String = "";
			var d:Date = new Date();
			
			// Format date
			if(includeDate)
			{
				this._dateFormatter.formatString = "MM/DD/YYYY";
				date = this._dateFormatter.format(d) + fieldSeparator;
			}
			
			// Format time
			if(includeTime)
			{
				this._dateFormatter.formatString = "J:N:SS.QQQ";
				date += '[' + this._dateFormatter.format(d) + ']' + fieldSeparator;
			}
			
			// Find the category
			var category:String = includeCategory ? ILogger(event.target).category + fieldSeparator : "";
                              
            // Then output it in firebug
            if(ExternalInterface.available)
            {
				ExternalInterface.call("console."+levelType, date + level + category + event.message);
            }
		}
		
		/**
		 * Returns the string equivalend of the level enum.
		 * This is needed for firebug to understand the console output.
		 **/
		private function getLevelString(level:int):String
		{
     		switch(level)
			{
				case LogEventLevel.DEBUG: 
					return 'debug';
					break;
				case LogEventLevel.INFO: 
					return 'info';
					break;
				case LogEventLevel.WARN: 
					return 'warn';
					break;
				case LogEventLevel.FATAL: 
				case LogEventLevel.ERROR: 
					return 'error';
					break;
				case LogEventLevel.ALL: 
				default: 
					return 'log';
					break;
			}
		}
	}
}