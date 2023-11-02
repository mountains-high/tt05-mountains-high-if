
/*
    First-order integrate-and-fire neuron model.
    Input is assumed to be a current injection.
    
    For :math:`U[T] > U_{\\rm thr} ⇒ S[T+1] = 1`.

    If `reset_mechanism = "subtract"`, then :math:`U[t+1]` will have
    `threshold` subtracted from it whenever the neuron emits a spike:

    .. math::

            U[t+1] = U[t] + I_{\\rm in}[t+1] - RU_{\\rm thr}

    If `reset_mechanism = "zero"`, then :math:`U[t+1]` will be set to `0`
    whenever the neuron emits a spike:

    .. math::

            U[t+1] = U[t] + I_{\\rm syn}[t+1] - R(U[t] + I_{\\rm in}[t+1])

      :math:`I_{\\rm in}` - Input current
      :math:`U` - Membrane potential
      :math:`U_{\\rm thr}` - Membrane threshold
      :math:`R` - Reset mechanism: if active, :math:`R = 1`, otherwise \
        :math:`R = 0`
*/
`default_nettype none

module if_neuron ( 
    input wire [7:0] current,
    input wire       clk,
    input wire       rst_n,
    output wire      spike,
    output reg [7:0] state
);
    reg  [7:0] threshold;
    wire [7:0] next_state;
    

always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 230;
        end else begin
            state <= next_state;
        end
    end

    // next_state logic and spiking logic
    assign spike = (state >= threshold);
    assign next_state = (spike ? 0 : (state + current)) - (spike ? threshold : 0);


endmodule