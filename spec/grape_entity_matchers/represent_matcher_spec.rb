require 'spec_helper'
require 'grape_entity'

describe GrapeEntityMatchers do
  before(:all) do
    class PetEntity < Grape::Entity
      expose :name, :age
    end
    class Person
      include Grape::Entity::DSL
      entity :name, :age do
        expose :date_of_birth, :as => :birthday
        expose :cat, :as => :feline, :using => PetEntity
        expose :dog, :using => PetEntity
        expose :secret, :if => lambda{ |person, options| person.authorized? }
        expose :super_dooper_secret, :as => :top_secret, :if => lambda{ |person, options| person.authorized? }
      end
    end
    class Vet < Grape::Entity
      root 'vets', 'vet'
      expose :name
    end
    class ItemEntity < Grape::Entity
      expose :name
      expose :name, as: :title
      expose :sub_items, as: :children, using: ItemEntity
    end
    nil
  end

  context 'matchers' do
    subject(:entity) { Person::Entity }

    # TODO: move the tests to this format to shadow the thoughtbot tests.
    # it { should represent(:name) }
    context "should ensure the representation includes the specified property" do
      it { should represent :name}
    end
    
    it { should represent :name}
    
    it { should represent(:date_of_birth).as(:birthday) }
    
    it { should_not represent(:t_shirt_size) }
    it { should_not represent(:t_shirt_size).as(:birthday) }
    it { should_not represent(:name).as(:brithday) }
    it { should_not represent(:date_of_birth) }
    
    it { should represent(:secret).when( :authorized? => true ) }
    it { should_not represent(:secret).when( :authorized? => false ) }

    it { should represent(:super_dooper_secret).as(:top_secret).when( :authorized? => true ) }
    it { should_not represent(:super_dooper_secret).as(:top_secret).when( :authorized? => false ) }
    it { should_not represent(:super_dooper_secret).when( :authorized? => true ) }
    
    it { should represent(:dog).using(PetEntity) }
    it { should represent(:cat).as(:feline).using(PetEntity) }
    it { should_not represent(:cat).using(PetEntity) }

  end

  context 'matchers within a root' do
    subject(:entity) { Vet }
    it { should represent(:name).with_root('vet') }
  end

  context 'matchers with with a tree structure' do
    subject(:entity) { ItemEntity }
    it { should represent(:name).as(:title) }
    it { should represent(:sub_items).as(:children).using(ItemEntity) }
  end
end
