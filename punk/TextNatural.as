package punk 
{
	import punk.core.Entity;
	
	/**
	 * This class provides natural text rendering functionality.
	 * Some code is borrowed / modified from the AS3 documentation.
	 * @author James Rhodes
	 */
	/// @info	Provides natural text rendering for FlashPunk games.  Written by James Rhodes (Roket Enterprises).
	public class TextNatural extends Entity
	{
		/// @info	The text string to render.
		public var text:String = "";
		
		/// @info	The foreground color of the text.
		public var foreColor:uint = 0xFFFFFF;
		
		/// @info	The opacity of the text that is drawn (0 = fully transparent, 1 = fully opaque).
		public var foreAlpha:Number = 1;
		
		/// @info	The name of the font as a string.  You can specify a single name, or a comma-delimited list
		///			of names to search for.  For example "Arial, Helvetica, _sans" causes the player to search
		///			for "Arial", then "Helvetica" if Arial is not found, then _sans if neither is found.
		///			
		///			Flash supports three generic device font names:
		///				_sans (like Helvetica and Arial),
		///				_serif (like Times Roman), and
		///				_typewriter (like Courier).
		///			These are mapped to specific device fonts depending on the platform.
		public var fontName:String = "_sans";
		
		/// @info	The size of the font in pixels (default 12px).
		public var fontSize:Number = 12;
		
		/// @info	Should the font be bold?
		public var fontBold:Boolean = false;
		
		/// @info	Should the font be italic?
		public var fontItalic:Boolean = false;
		
		/// @info	The maximum width of the text.  This allows you to automatically wrap words.  -1 indicates
		///			no wrapping.
		public var maxWidth:Number = -1;
		
		/// @info	The color which will be displayed behind the text.  If the background alpha is greater than 0,
		///			the area to which the text will be drawn will be filled with the specified color at the
		///			specified opacity.
		public var backColor:uint = 0x000000;
		
		/// @info	The opacity for the background.  0 indicated no background (completely transparent).
		public var backAlpha:Number = 0;
		
		/// @info	Indicates the width of the text drawn.  This can be used for text alignment.  Changing this
		///			variable will have no effect.
		//public var width:Number = -1;
		
		/// @info	Indicates the height of the text drawn.  This can be used for text alignment.   Changing this
		///			variable will have no effect.
		//public var height:Number = -1;
		
		/// @info	Indicates the height of the first line of text drawn.  This can be used for text alignment.   Changing this
		///			variable will have no effect.
		public var firstHeight:Number = -1;
		
		private var control:TextController;
		
		/// @info	Draws a smooth, antialiased line to the Screen.
		/// @param	text			The text string to render.
		/// @param	foreColor		The foreground color of the text.
		/// @param	foreAlpha		The opacity of the text that is drawn (0 = fully transparent, 1 = fully opaque).
		/// @param	fontName		The name of the font as a string.  You can specify a single name, or a comma-delimited list
		///							of names to search for.  For example "Arial, Helvetica, _sans" causes the player to search
		///							for "Arial", then "Helvetica" if Arial is not found, then _sans if neither is found.
		///							
		///							Flash supports three generic device font names:
		///								_sans (like Helvetica and Arial),
		///								_serif (like Times Roman), and
		///								_typewriter (like Courier).
		///							These are mapped to specific device fonts depending on the platform.
		/// @param	fontSize		The size of the font in pixels (default 12px).
		/// @param	fontBold		Should the font be bold?
		/// @param	fontItalic		Should the font be italic?
		/// @param	maxWidth		The maximum width of the text.  This allows you to automatically wrap words.  -1 indicates
		///							no wrapping.
		/// @param	backColor		The color which will be displayed behind the text.  If the background alpha is greater than 0,
		///							the area to which the text will be drawn will be filled with the specified color at the
		///							specified opacity.  This will not work correctly if you do not specify a word-wrapping width as
		///							the drawing region is based on the x position, y position and the width and height of the
		///							text drawn.
		/// @param	backAlpha		The opacity for the background.  0 indicated no background (completely transparent).
		public function TextNatural(text:String, foreColor:uint = 0xFFFFFF, foreAlpha:Number = 1, fontName:String = "_sans", fontSize:Number = 12, fontBold:Boolean = false, fontItalic:Boolean = false, maxWidth:Number = -1, backColor:uint = 0x000000, backAlpha:Number = 0) 
		{
			this.text = text;
			this.foreColor = foreColor;
			this.foreAlpha = foreAlpha;
			this.fontName = fontName;
			this.fontSize = fontSize;
			this.fontBold = fontBold;
			this.fontItalic = fontItalic;
			this.backColor = backColor;
			this.backAlpha = backAlpha;
			this.maxWidth = maxWidth;
			
			this.control = new TextController(this.text, this.foreColor, this.foreAlpha, this.fontSize, this.x, this.y, this.fontName, this.fontBold, this.fontItalic, this.maxWidth)
			this.width = this.control.width;
			this.height = this.control.height;
			this.firstHeight = this.control.firstHeight;
		}
		
		/// @info	Renders the text onto the screen.  Make sure you set the x and y properties of the text before calling this function.
		override public function render():void
		{
			// Renders the font to the screen
			this.control.updateSettings(this.text, this.foreColor, this.foreAlpha, this.fontSize, this.x, this.y, this.fontName, this.fontBold, this.fontItalic, this.maxWidth);
			this.control.graphics.clear();
			this.width = this.control.width;
			this.height = this.control.height;
			this.firstHeight = this.control.firstHeight;
			FP.screen.draw(this.control);
		}
	}
}

internal import flash.text.engine.FontDescription;
internal import flash.display.Sprite;
internal import flash.text.engine.TextBlock;
internal import flash.text.engine.TextElement;
internal import flash.text.engine.TextLine;
internal import flash.text.engine.ElementFormat;
internal import flash.text.engine.FontPosture;
internal import flash.text.engine.FontWeight;
internal import flash.text.engine.TextBaseline;

internal class TextController extends Sprite {
    private var textWidth:Number = -1;
	public var firstHeight:Number = 0;
	
	public function TextController(text:String, foreColor:uint, foreAlpha:Number, size:Number, x:Number, y:Number, fontName:String, bold:Boolean, italic:Boolean, maxwidth:Number)
	{
		updateSettings(text, foreColor, foreAlpha, size, x, y, fontName, bold, italic, maxwidth);
	}
	
	public function updateSettings(text:String, foreColor:uint, foreAlpha:Number, size:Number, x:Number, y:Number, fontName:String, bold:Boolean, italic:Boolean, maxwidth:Number):void
	{
		var str:String = text;
		this.x = x;
		this.y = y;
		
		var boldSetting:String = FontWeight.NORMAL;
		var italicSetting:String = FontPosture.NORMAL;
		if (bold) boldSetting = FontWeight.BOLD;
		if (italic) italicSetting = FontPosture.ITALIC;
		
		var font:FontDescription = new FontDescription(fontName, boldSetting, italicSetting);
		var format:ElementFormat = new ElementFormat(null, size, foreColor, foreAlpha, "auto", TextBaseline.IDEOGRAPHIC_BOTTOM, TextBaseline.IDEOGRAPHIC_BOTTOM);
		format.fontDescription = font;
		var textElement:TextElement = new TextElement(str, format); 
		var textBlock:TextBlock = new TextBlock();
		textBlock.content = textElement; 
		
		textWidth = maxwidth;
		if (textWidth <= 0)
			textWidth = 1000000;
		
		// clears the previous text objects
		while (this.numChildren > 0)
			removeChildAt(0);
		
		createLines(textBlock);
	}
	
	private function createLines(textBlock:TextBlock):void {
		// This function formats the text into multiple lines
		this.height = 0;
		this.firstHeight = 0;
		this.width = 0;
		
		var yPos:Number = this.y;
		var textLine:TextLine = textBlock.createTextLine(null, textWidth);
		this.firstHeight = textLine.height;
		while (textLine)
		{
			addChild(textLine);
			textLine.x = this.x;
			textLine.y = yPos;
			if (this.width < textLine.width) this.width = textLine.width;
			yPos += Math.ceil(textLine.height + 2);
			textLine = textBlock.createTextLine(textLine, textWidth);
		}
		this.height = yPos - this.y - firstHeight;
	}
}