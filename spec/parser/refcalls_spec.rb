require 'spec_helper'

RSpec.describe('Refcall parsing') do
  include_examples 'parse', /(abc)\1/,
    1 => [:backref, :number, Backreference::Number, number: 1]

  include_examples 'parse', /(?<X>abc)\k<X>/,
    1 => [:backref, :name_ref, Backreference::Name, name: 'X']
  include_examples 'parse', /(?<X>abc)\k'X'/,
    1 => [:backref, :name_ref, Backreference::Name, name: 'X']

  include_examples 'parse', /(abc)\k<1>/,
    1 => [:backref, :number_ref, Backreference::Number, number: 1]
  include_examples 'parse', /(abc)\k'1'/,
    1 => [:backref, :number_ref, Backreference::Number, number: 1]

  include_examples 'parse', /(abc)\k<-1>/,
    1 => [:backref, :number_rel_ref, Backreference::NumberRelative, number: -1]
  include_examples 'parse', /(abc)\k'-1'/,
    1 => [:backref, :number_rel_ref, Backreference::NumberRelative, number: -1]

  include_examples 'parse', /(?<X>abc)\g<X>/,
    1 => [:backref, :name_call, Backreference::NameCall, name: 'X']
  include_examples 'parse', /(?<X>abc)\g'X'/,
    1 => [:backref, :name_call, Backreference::NameCall, name: 'X']

  include_examples 'parse', /(abc)\g<1>/,
    1 => [:backref, :number_call, Backreference::NumberCall, number: 1]
  include_examples 'parse', /(abc)\g'1'/,
    1 => [:backref, :number_call, Backreference::NumberCall, number: 1]

  include_examples 'parse', '\g<0>',
    0 => [:backref, :number_call, Backreference::NumberCall, number: 0]
  include_examples 'parse', "\\g'0'",
    0 => [:backref, :number_call, Backreference::NumberCall, number: 0]

  include_examples 'parse', /(abc)\g<-1>/,
    1 => [:backref, :number_rel_call, Backreference::NumberCallRelative, number: -1]
  include_examples 'parse', /(abc)\g'-1'/,
    1 => [:backref, :number_rel_call, Backreference::NumberCallRelative, number: -1]

  include_examples 'parse', /\g<+1>(abc)/,
    0 => [:backref, :number_rel_call, Backreference::NumberCallRelative, number: 1]
  include_examples 'parse', /\g'+1'(abc)/,
    0 => [:backref, :number_rel_call, Backreference::NumberCallRelative, number: 1]

  include_examples 'parse', /(?<X>abc)\k<X-0>/,
    1 => [:backref, :name_recursion_ref,   Backreference::NameRecursionLevel,
          name: 'X', recursion_level: 0]
  include_examples 'parse', /(?<X>abc)\k'X-0'/,
    1 => [:backref, :name_recursion_ref,   Backreference::NameRecursionLevel,
          name: 'X', recursion_level: 0]

  include_examples 'parse', /(abc)\k<1-0>/,
    1 => [:backref, :number_recursion_ref, Backreference::NumberRecursionLevel,
          number: 1, recursion_level: 0]
  include_examples 'parse', /(abc)\k'1-0'/,
    1 => [:backref, :number_recursion_ref, Backreference::NumberRecursionLevel,
          number: 1, recursion_level: 0]
  include_examples 'parse', /(abc)\k'-1+0'/,
    1 => [:backref, :number_recursion_ref, Backreference::NumberRecursionLevel,
          number: -1, recursion_level: 0]
  include_examples 'parse', /(abc)\k'1+1'/,
    1 => [:backref, :number_recursion_ref, Backreference::NumberRecursionLevel,
          number: 1, recursion_level: 1]
  include_examples 'parse', /(abc)\k'1-1'/,
    1 => [:backref, :number_recursion_ref, Backreference::NumberRecursionLevel,
          number: 1, recursion_level: -1]

  # test #effective_number
  include_examples 'parse', '(abc)(def)\k<-1>(ghi)\k<-3>\k<-1>',
    2 => [:number_rel_ref, effective_number: 2],
    4 => [:number_rel_ref, effective_number: 1],
    5 => [:number_rel_ref, effective_number: 3]

  include_examples 'parse', '\g<+1>(abc)\g<+2>(def)(ghi)\g<-2>',
    0 => [:number_rel_call, effective_number: 1],
    2 => [:number_rel_call, effective_number: 3],
    5 => [:number_rel_call, effective_number: 2]

  specify('parse backref referenced_expression') do
    root = RP.parse('(abc)(def)\\k<-1>(ghi)\\k<-3>\\k<-1>')
    exp1 = root[2]
    exp2 = root[4]
    exp3 = root[5]

    expect([exp1, exp2, exp3]).to all be_instance_of(Backreference::NumberRelative)

    expect(exp1.referenced_expression).to eq root[1]
    expect(exp1.referenced_expression.to_s).to eq '(def)'
    expect(exp2.referenced_expression).to eq root[0]
    expect(exp2.referenced_expression.to_s).to eq '(abc)'
    expect(exp3.referenced_expression).to eq root[3]
    expect(exp3.referenced_expression.to_s).to eq '(ghi)'
  end

  specify('parse backref call referenced_expression') do
    root = RP.parse('\\g<+1>(abc)\\g<+2>(def)(ghi)\\g<-2>')
    exp1 = root[0]
    exp2 = root[2]
    exp3 = root[5]

    expect([exp1, exp2, exp3]).to all be_instance_of(Backreference::NumberCallRelative)
    expect(exp1.referenced_expression).to eq root[1]
    expect(exp1.referenced_expression.to_s).to eq '(abc)'
    expect(exp2.referenced_expression).to eq root[4]
    expect(exp2.referenced_expression.to_s).to eq '(ghi)'
    expect(exp3.referenced_expression).to eq root[3]
    expect(exp3.referenced_expression.to_s).to eq '(def)'
  end
end
