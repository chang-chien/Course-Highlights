
public class JointAccount extends Account {
	
	public JointAccount (double totalAmount) {
		super(totalAmount);
	}
	
	public void spend(double amount) {
		if (this.totalAmount - amount < 0) {
			System.out.println("Not enough money to deduct");
		} else {
			this.totalAmount = this.totalAmount - amount;
		}
	}
}
