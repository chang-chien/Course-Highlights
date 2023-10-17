public class UserAccount extends Account{
	private String name;
//	¤w½ÆÀËÀ³­t
	public UserAccount(String name, double totalAmount) {
		super(totalAmount);
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
	public void oweMoney(double amount) {
		this.totalAmount = this.totalAmount - amount;
	}
}
