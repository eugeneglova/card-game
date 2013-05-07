# encoding: utf-8

class Card
	attr_accessor :weight, :value, :suit
	def initialize value, suit
		@weight = value
		@value = value
		@suit = suit
		if value > 10
			@value =
			case value
				when 11 then 'J'
				when 12 then 'Q'
				when 13 then 'K'
				when 14 then 'A'
			end
		end
	end
	def to_s
		@value.to_s.rjust(4) + ' ' + @suit
	end
end

class Deck
	attr_reader :deck
	def initialize
		@instance = nil
		# @suits = %w{ Hearts Clubs Spades Diamonds }
		@suits = ["\342\231\245", "\342\231\243", "\342\231\240", "\342\231\246"]
		blend
	end
	def blend
		@deck = []
		52.times do |n|
			@deck.push Card.new n % 13 + 2, @suits[n % 4]
			@deck.push @deck.delete_at rand @deck.length
		end
	end
	def self.get_instance
		@instance || @instance = self.new
	end
	def length
		@deck.length
	end
	def pop
		[
			(@deck.delete_at 0),
			(@deck.delete_at 0),
			(@deck.delete_at 0),
			(@deck.delete_at 0),
		]
	end
end

class Table
	def initialize
		@table = {
			0 => [],
			1 => [],
			2 => [],
			3 => [],
		}
	end
	def push cards
		4.times do |n|
			@table[n].push cards[n]
		end
		draw
		remove
	end
	def remove
		# p 'remove start'
		i = 0
		while i < 4
			j = 0
			c = @table[i].last
			while j < 4
				if i != j
					c1 = @table[j].last
					if c && c1
						# print 'c = ' + c.to_s + ' c1 = ' + c1.to_s + "\n"
						if c.suit == c1.suit
							# print 'compare ' + c.to_s + ' with ' + c1.to_s + "\n"
							if c.weight > c1.weight
								print 'remove  ' + c1.to_s + "\n"
								@table[j].pop
								i = -1
								j = 4
								draw
								move
								break
							end
						end
					end
				end
				j += 1
				# p 'j++ ' + j.to_s
			end
			i += 1
			# p 'i++ ' + i.to_s
		end
		# p 'remove end'
	end
	def move
		# p 'move start'
		empty_key = nil
		@table.each do |key, value|
			if value.length == 0
				empty_key = key
				break
			end
		end
		if empty_key
			# p 'empty ' + empty_key.to_s
			max_weight_key = nil
			max_weight = 0
			@table.each do |key, value|
				if value.length > 1
					if max_weight < @table[key].last.weight
						max_weight = @table[key].last.weight
						max_weight_key = key
					end
				end
			end
			if max_weight_key
				# p 'max ' + max_weight_key.to_s
				c = @table[max_weight_key].delete_at(@table[max_weight_key].length - 1)
				@table[empty_key].push c
				print 'move ' + c.to_s + '   to ' + (empty_key + 1).to_s + " position\n"
				draw
			end
		end
		# p 'move end'
	end
	def draw
		la = []
		@table.each do |key, value|
			la.push value.length
		end
		la.max.times do |n|
			@table.each do |key, value|
				print value[n].to_s.ljust 6
			end
			puts
		end
		puts '-' * 27
	end
	def success?
		la = []
		@table.each do |key, value|
			la.push value.length
		end
		# p la
		la.min == 1 && la.max == 1
	end
end	

i = 0
begin
	t = Table.new
	d = Deck::get_instance
	d.blend
	deck = d.deck.dup
	while d.length > 0 do
		t.push d.pop
		#break
	end
	i += 1
end until t.success?

p 'success after ' + i.to_s + ' times'
p deck
