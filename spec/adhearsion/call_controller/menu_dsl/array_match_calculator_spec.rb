# encoding: utf-8

require 'spec_helper'

module Adhearsion
  class CallController
    module MenuDSL
      describe ArrayMatchCalculator do

        let(:match_payload) { :doesnt_matter }

        it "matching arrays with fixnums" do
          calculator = ArrayMatchCalculator.new [11,5,14,115], match_payload
          match_case = calculator.match '11'
          match_case.should be_exact_match
          match_case.should be_potential_match
          match_case.exact_matches.should be == [11]
          match_case.potential_matches.should be == [115]
        end

        it "matching arrays with strings with digits and special digits" do
          calculator = ArrayMatchCalculator.new %w[*57 4 *54 115 ###], match_payload
          match_case = calculator.match '*5'
          match_case.should_not be_exact_match
          match_case.should be_potential_match
          match_case.potential_matches.should be == %w[*57 *54]

          match_case = calculator.match '*57'
          match_case.should be_exact_match
          match_case.should_not be_potential_match
          match_case.exact_matches.should be == %w[*57]
        end

        it "matching an array with a combination of Fixnums and Strings" do
          calculator = ArrayMatchCalculator.new ['11',5,'14',115], match_payload
          match_case = calculator.match '11'
          match_case.should be_exact_match
          match_case.should be_potential_match
          match_case.exact_matches.should be == ['11']
          match_case.potential_matches.should be == [115]
        end

        it "matching empty array should never match" do
          calculator = ArrayMatchCalculator.new [], match_payload
          match_case = calculator.match '98'
          match_case.should_not be_exact_match
          match_case.should_not be_potential_match
          match_case.exact_matches.should be == []
          match_case.potential_matches.should be == []

          match_case = calculator.match '*2'
          match_case.should_not be_exact_match
          match_case.should_not be_potential_match
          match_case.exact_matches.should be == []
          match_case.potential_matches.should be == []
        end

        it "matching array with nil should skip nil field" do
          pattern = [1,2,nil,5,10]
          calculator = ArrayMatchCalculator.new pattern, match_payload
          match_case = calculator.match '1'
          match_case.should be_exact_match
          match_case.should be_potential_match
          match_case.exact_matches.should be == [1]
          match_case.potential_matches.should be == [10]

          match_case = calculator.match '99'
          match_case.should_not be_exact_match
          match_case.should_not be_potential_match

          pattern.should == [1,2,nil,5,10]
        end
      end
    end
  end
end
