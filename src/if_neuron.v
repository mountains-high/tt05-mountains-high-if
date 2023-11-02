
/*
    First-order leaky integrate-and-fire neuron model.
    Input is assumed to be a current injection.
    Membrane potential decays exponentially with rate beta.
    For :math:`U[T] > U_{\\rm thr} ⇒ S[T+1] = 1`.

    If `reset_mechanism = "subtract"`, then :math:`U[t+1]` will have
    `threshold` subtracted from it whenever the neuron emits a spike:

    .. math::

            U[t+1] = βU[t] + I_{\\rm in}[t+1] - RU_{\\rm thr}

    If `reset_mechanism = "zero"`, then :math:`U[t+1]` will be set to `0`
    whenever the neuron emits a spike:

    .. math::

            U[t+1] = βU[t] + I_{\\rm syn}[t+1] - R(βU[t] + I_{\\rm in}[t+1])

      :math:`I_{\\rm in}` - Input current
      :math:`U` - Membrane potential
      :math:`U_{\\rm thr}` - Membrane threshold
      :math:`R` - Reset mechanism: if active, :math:`R = 1`, otherwise \
        :math:`R = 0`
      :math:`β` - Membrane potential decay rate
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
    

always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 8'b0;
            threshold <= 8'hE6;  // Example threshold value
        end else if (state >= threshold) begin
            state <= 8'b0;  // Reset the state when the threshold is crossed
        end else begin
            state <= state + current;
        end
    end

    // Spiking logic
    assign spike = (state >= threshold);


endmodule

