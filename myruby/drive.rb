require './reader'
require './evaluator'

ast = Reader.read_str("(- (+ 5 2) 10)")
rep(ast)
