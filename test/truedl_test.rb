# frozen_string_literal: true

require "test_helper"

class TrueDLTest < Minitest::Test
  def setup
    @teams_a = [
      {id: 1, points: 7, ranking: 500},
      {id: 2, points: 6, ranking: 1500},
      {id: 3, points: 6, ranking: 750},
      {id: 4, points: 3, ranking: 1500},
      {id: 5, points: 3, ranking: 500},
      {id: 6, points: 3, ranking: 500},
      {id: 7, points: 2, ranking: 5500}
    ]

    @teams_b = [
      {id: 1, points: 22, ranking: 150},
      {id: 2, points: 16, ranking: 2500},
      {id: 3, points: 13, ranking: 750},
      {id: 4, points: 8, ranking: 1500}
    ]
  end

  def test_it_returns_correct_coefficients
    assert_equal 1.61, TrueDL.coefficient_for_place(1)
    assert_equal 1.61, TrueDL.coefficient_for_place(2)
    assert_equal 1.61, TrueDL.coefficient_for_place(1.5)

    assert_equal 1.52, TrueDL.coefficient_for_place(11)
    assert_equal 1.52, TrueDL.coefficient_for_place(25)

    assert_equal 1.43, TrueDL.coefficient_for_place(26)
    assert_equal 1.43, TrueDL.coefficient_for_place(50)

    assert_equal 1.32, TrueDL.coefficient_for_place(51)
    assert_equal 1.32, TrueDL.coefficient_for_place(100)

    assert_equal 1.16, TrueDL.coefficient_for_place(101)
    assert_equal 1.16, TrueDL.coefficient_for_place(250)

    assert_equal 1.0, TrueDL.coefficient_for_place(251)
    assert_equal 1.0, TrueDL.coefficient_for_place(500)

    assert_equal 0.81, TrueDL.coefficient_for_place(501)
    assert_equal 0.81, TrueDL.coefficient_for_place(1000)

    assert_equal 0.6, TrueDL.coefficient_for_place(1001)
    assert_equal 0.6, TrueDL.coefficient_for_place(2000)

    assert_equal 0.43, TrueDL.coefficient_for_place(2001)
    assert_equal 0.43, TrueDL.coefficient_for_place(3000)

    assert_equal 0.31, TrueDL.coefficient_for_place(3001)
    assert_equal 0.31, TrueDL.coefficient_for_place(5000)

    assert_nil TrueDL.coefficient_for_place(9999)
    assert_nil TrueDL.coefficient_for_place(5001)
    assert_nil TrueDL.coefficient_for_place(-1)
    assert_nil TrueDL.coefficient_for_place(nil)
  end

  def test_truedl_for_team
    assert_in_delta 5.0, TrueDL.truedl_for_team(team_points: 29, team_ranking: 5, number_of_questions: 36), 0.01

    assert_in_delta 3.97, TrueDL.truedl_for_team(team_points: 35, team_ranking: 5, number_of_questions: 36), 0.01
    assert_in_delta 3.97, TrueDL.truedl_for_team(team_points: 31, team_ranking: 50, number_of_questions: 36), 0.01
    assert_in_delta 4.01, TrueDL.truedl_for_team(team_points: 25, team_ranking: 250, number_of_questions: 36), 0.01
    assert_in_delta 0, TrueDL.truedl_for_team(team_points: 16, team_ranking: 2500, number_of_questions: 36), 0.01

    assert_in_delta 7.06, TrueDL.truedl_for_team(team_points: 17, team_ranking: 5, number_of_questions: 36), 0.01
    assert_in_delta 7.06, TrueDL.truedl_for_team(team_points: 17, team_ranking: 5.5, number_of_questions: 36), 0.01
    assert_in_delta 7.09, TrueDL.truedl_for_team(team_points: 15, team_ranking: 50, number_of_questions: 36), 0.01
    assert_in_delta 6.89, TrueDL.truedl_for_team(team_points: 13, team_ranking: 250, number_of_questions: 36), 0.01

    assert_nil TrueDL.truedl_for_team(team_points: 13, team_ranking: 5001, number_of_questions: 36)
    assert_nil TrueDL.truedl_for_team(team_points: 13, team_ranking: -1, number_of_questions: 36)
    assert_nil TrueDL.truedl_for_team(team_points: 13, team_ranking: nil, number_of_questions: 36)
    assert_nil TrueDL.truedl_for_team(team_points: nil, team_ranking: 1, number_of_questions: 36)
    assert_nil TrueDL.truedl_for_team(team_points: 13, team_ranking: 1, number_of_questions: nil)
    assert_nil TrueDL.truedl_for_team(team_points: 13, team_ranking: 1, number_of_questions: -5)
  end

  def test_truedls_for_tournament_a
    expected_dls = [
      TrueDL::TeamDL.new(id: 1, dl: 8.056),
      TrueDL::TeamDL.new(id: 2, dl: 7.222),
      TrueDL::TeamDL.new(id: 3, dl: 7.942),
      TrueDL::TeamDL.new(id: 4, dl: 8.611),
      TrueDL::TeamDL.new(id: 5, dl: 9.167),
      TrueDL::TeamDL.new(id: 6, dl: 9.167)
    ]

    assert_equal expected_dls, TrueDL.true_dls_for_tournament(teams: @teams_a, number_of_questions: 36)
  end

  def test_truedls_for_tournament_b
    expected_dls = [
      TrueDL::TeamDL.new(id: 1, dl: 4.732),
      TrueDL::TeamDL.new(id: 2, dl: 0),
      TrueDL::TeamDL.new(id: 3, dl: 5.542),
      TrueDL::TeamDL.new(id: 4, dl: 6.296)
    ]

    assert_equal expected_dls, TrueDL.true_dls_for_tournament(teams: @teams_b, number_of_questions: 36)
  end

  def test_truedl_for_tournament
    assert_in_delta 8.36, TrueDL.true_dl_for_tournament(teams: @teams_a, number_of_questions: 36), 0.01
    assert_in_delta 4.14, TrueDL.true_dl_for_tournament(teams: @teams_b, number_of_questions: 36), 0.01
  end
end
