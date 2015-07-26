class Compiler

  TAG_START = '<\*'
  TAG_END = '\*>'
  TAG = /(#{TAG_START}.*?#{TAG_END})/
  END_EACH = /(#{TAG_START}\WENDEACH\W#{TAG_END})/
  START_EACH = /(#{TAG_START}\WEACH.*?#{TAG_END})/

  def self.compile(tokens)
    root_node = RootNode.new(nil)
    context_stack = [root_node]
    tokens.each do |token|
      if token =~ END_EACH
        context_stack.pop
      elsif token =~ START_EACH
        new_node = add_child_to_the_context(token, context_stack)
        context_stack.push(new_node)
      else
        add_child_to_the_context token, context_stack
      end
    end
    return root_node
  end

private
  def self.add_child_to_the_context(token, context_stack)
    new_node = create_node token
    context_node = context_stack.last
    context_node.children << new_node
    new_node
  end

  def self.create_node(token)
    if token =~ TAG
      if token.include? 'EACH'
        return EachNode.new clean(token)
      else
        return VariableNode.new clean(token)
      end
    else
      return TextNode.new token
    end
  end

  def self.clean(token)
    token[2...-2].strip
  end

end