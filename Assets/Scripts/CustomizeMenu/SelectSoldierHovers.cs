
using UnityEngine;

using UnityEngine.UI;

public class SelectSoldierHovers : MonoBehaviour
{

    [SerializeField] private Sprite GreenButton;
    [SerializeField] private Image buttonImage;
    [SerializeField] private Sprite WhiteButton;

    public void OnMouseOver()
    {
        buttonImage.sprite = GreenButton;
    }

    public void OnMouseExit()
    {
        buttonImage.sprite = WhiteButton;
    }

    public void Click(int soldierIndex)
    {
        CharacterSelectorManager.Instance.SpawnSoldier(soldierIndex);
      
    }
}
