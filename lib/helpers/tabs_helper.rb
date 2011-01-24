# http://forum.jquery.com/topic/jquery-datepicker-pick-multiple-dates
# module JqueryUiRailsHelpers

	module TabsHelper
	  def verticle_tabs_for( *options, &block )
	    raise ArgumentError, "Missing block" unless block_given?
	    raw TabsHelper::TabsRenderer.new( *options, &block ).render
	  end

	  def tabs_for( *options, &block )
	    raise ArgumentError, "Missing block" unless block_given?
	    raw TabsHelper::TabsRenderer.new( *options, &block ).render
	  end

	  class TabsRenderer

	    def initialize( options={}, &block )
	      raise ArgumentError, "Missing block" unless block_given?

	      @template = eval( 'self', block.binding )
	      @options = options
	      @tabs = []

	      yield self
	    end

	    def create( tab_id, tab_text, options={}, &block )
	      raise "Block needed for TabsRenderer#CREATE" unless block_given?
	      @tabs << [ tab_id, tab_text, options, block ]
	    end

	    def render
	      content_tag( :div, raw([render_tabs, render_bodies]), { :id => :tabs }.merge( @options ) )
	    end

	  private #  ---------------------------------------------------------------------------

	    def render_tabs
	      content_tag :ul do
	        result = @tabs.collect do |tab|
	          content_tag( :li, link_to( content_tag( :span, raw(tab[1]) ), "##{tab[0]}" ) )
	        end.join
					raw(result)
	      end
	    end

	    def  render_bodies
	      @tabs.collect do |tab|
	        content_tag( :div, capture( &tab[3] ), tab[2].merge( :id => tab[0] ) )
	      end.join.to_s
	    end

	    def method_missing( *args, &block )
	      @template.send( *args, &block )
	    end

	  end
	end

# end