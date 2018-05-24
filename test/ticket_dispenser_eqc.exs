defmodule TicketDispenser_eqc do
  use ExUnit.Case, async: false
  use EQC.ExUnit
  use EQC.StateM

  # alias :ticket_dispenser, as: SUT
  alias TicketDispenser, as: SUT
  # alias TicketAgent, as: SUT

  def initial_state() do
    0
  end

  ## reset command
  def reset_args(_state), do: [var: :pid]

  def reset(pid), do: SUT.reset(pid)

  def reset_next(_state, _var, [_pid]), do: 0

  def reset_post(_state, [_pid], result), do: eq(result, 0)

  ## take command
  def take_args(_state), do: [var: :pid]

  def take(pid), do: SUT.take(pid)

  def take_next(state, _var, [_pid]), do: state + 1

  def take_post(state, [_pid], result), do: eq(result, state + 1)

  # 	weight state,
  # 	   take: 10,
  #    reset: state

  property "random_ticket_sequence" do
    # commands are "generated" by looking at public function with a specific pattern
    # for ex. command 'take' is defined using functions take/1, take_args/1 and take_next/3.
    # take_post/3 is optional, but definitely recommended (as is take_pre/2, not specified in this example)
    # http://propertesting.com/book_case_study_stateful_properties_with_a_bookstore.html is a more elaborate example
    forall cmds <- parallel_commands(__MODULE__) do
      {:ok, pid} = SUT.start()
      run_result = run_parallel_commands(__MODULE__, cmds, pid: pid)
      SUT.stop(pid)
      pretty_commands(__MODULE__, cmds, run_result, run_result[:result] == :ok)
    end
  end
end
