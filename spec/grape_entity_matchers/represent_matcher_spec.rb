require 'spec_helper'
require 'grape_entity'

describe GrapeEntityMatchers do
  before(:all) do
    class Person
      include Grape::Entity::DSL
      entity :name, :age do
        expose :date_of_birth, :as => :brithday
        expose :secret, :if => lambda{ |person, options| person.authorized? }
        expose :super_dooper_secret, :as => :top_secret, :if => lambda{ |person, options| person.authorized? }
      end
    end
  end

  context 'instance methods' do
    subject{ Person::Entity }
    
    let(:entity){ Person::Entity }

    # TODO: move the tests to this format to shadow the thoughtbot tests.
    # it { should represent(:name) }
    it "should ensure the representation includes the specified property" do
      entity.should represent :name
    end
    
    
    
    it { should represent(:date_of_birth).as(:brithday) }
    
    it { should_not represent(:t_shirt_size) }
    it { should_not represent(:t_shirt_size).as(:brithday) }
    it { should_not represent(:name).as(:brithday) }
    it { should_not represent(:date_of_birth) }
    
    it { should represent(:secret).when( :authorized? => true ) }
    it { should_not represent(:secret).when( :authorized? => false ) }
    
    it { should represent(:super_dooper_secret).as(:top_secret).when( :authorized? => true ) }
    it { should_not represent(:super_dooper_secret).as(:top_secret).when( :authorized? => false ) }
    it { should_not represent(:super_dooper_secret).when( :authorized? => true ) }

  end
end
