# frozen_string_literal: true

require_relative "truedl/version"

# Formula for TrueDL is described in this post: https://pecheny.me/blog/truedl/
module TrueDL
  TeamDL = Data.define(:id, :dl) do
    def ==(other)
      id == other.id && (dl - other.dl).abs < 0.001
    end
  end

  # @param [Integer, Float] place
  # @return [Float, nil]
  def self.coefficient_for_place(place)
    case place
    when 1..10 then 1.61
    when 11..25 then 1.52
    when 26..50 then 1.43
    when 51..100 then 1.32
    when 101..250 then 1.16
    when 251..500 then 1.0
    when 501..1000 then 0.81
    when 1001..2000 then 0.6
    when 2001..3000 then 0.43
    when 3001..5000 then 0.31
    end
  end

  # @param [Integer] team_points
  # @param [Integer, Float] team_ranking
  # @param [Integer] number_of_questions
  # @return [Float]
  def self.truedl_for_team(team_points:, team_ranking:, number_of_questions:)
    return if team_points.nil?
    return if number_of_questions.nil? || number_of_questions < 1
    return if team_ranking.nil? || team_ranking > 5000 || team_ranking < 1

    (1 - [team_points / coefficient_for_place(team_ranking), number_of_questions].min / number_of_questions) * 10
  end

  # Returns an array of TrueDL values for all teams
  #
  # @param [Array] teams: list of hashes with `id`, `points` and `ranking`: `{ id: 1,  points: 28, ranking: 22 }`
  # @param [Integer] number_of_questions
  # @return [Array<TeamTrueDl>]
  def self.true_dls_for_tournament(teams:, number_of_questions:)
    teams.map do |team|
      dl = truedl_for_team(team_points: team[:points], team_ranking: team[:ranking], number_of_questions:)
      next if dl.nil?

      TeamDL.new(id: team[:id], dl:)
    end.compact
  end

  # Calculates TrueDL for a tournament: an average of all non-nil team TrueDLs.
  # Might be nil for tournaments where all teams are ranked below top 5000.
  #
  # @param [Array] teams: list of hashes with `id`, `points` and `ranking`: `{ id: 1,  points: 28, ranking: 22 }`
  # @param [Integer] number_of_questions
  # @return [Float, nil]
  def self.true_dl_for_tournament(teams:, number_of_questions:)
    dls = true_dls_for_tournament(teams:, number_of_questions:)

    return if dls.empty?

    dls.map(&:dl).sum / dls.size
  end
end
