
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
    //assign spike = (state >= threshold);
    //assign next_state = (spike ? 0 : current) + (spike ? 0 : (state >> 1)+(state >> 2)+(state >> 3));

    // Spiking logic
    assign spike = (state >= threshold);
    
    always @(posedge clk or posedge rst_n) begin
        if (!rst_n) begin
            next_state <= 0;
        end else if (spike) begin
            next_state <= 0;
        end else begin
            next_state <= current;
        end
    end
    
endmodule

endmodule