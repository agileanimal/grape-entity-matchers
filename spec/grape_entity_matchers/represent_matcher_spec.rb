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
        format_with(:date_formatter) do |date|
          date
        end

        expose :date_of_birth, :as => :birthday, :format_with => :date_formatter
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
    # it { is_expected.to represent(:name) }
    context "ensure the representation includes the specified property" do
      it { is_expected.to represent :name}
    end

    it { is_expected.to represent :name}

    it { is_expected.to represent(:date_of_birth).as(:birthday).format_with(:date_formatter) }

    it { is_expected.to_not represent(:t_shirt_size) }
    it { is_expected.to_not represent(:t_shirt_size).as(:birthday) }
    it { is_expected.to_not represent(:name).as(:brithday) }
    it { is_expected.to_not represent(:date_of_birth) }

    it { is_expected.to represent(:secret).when( :authorized? => true ) }
    it { is_expected.to_not represent(:secret).when( :authorized? => false ) }

    it { is_expected.to represent(:super_dooper_secret).as(:top_secret).when( :authorized? => true ) }
    it { is_expected.to_not represent(:super_dooper_secret).as(:top_secret).when( :authorized? => false ) }
    it { is_expected.to_not represent(:super_dooper_secret).when( :authorized? => true ) }

    it { is_expected.to represent(:dog).using(PetEntity) }
    it { is_expected.to represent(:cat).as(:feline).using(PetEntity) }
    it { is_expected.to_not represent(:cat).using(PetEntity) }

  end

  context 'matchers within a root' do
    subject(:entity) { Vet }
    it { is_expected.to represent(:name).with_root('vet') }
  end

  context 'matchers with with a tree structure' do
    subject(:entity) { ItemEntity }
    it { is_expected.to represent(:name).as(:title) }
    it { is_expected.to represent(:sub_items).as(:children).using(ItemEntity) }
  end
end
