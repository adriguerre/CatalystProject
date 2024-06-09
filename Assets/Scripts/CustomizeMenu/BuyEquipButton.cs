using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class BuyEquipButton : MonoBehaviour
{

    
    [SerializeField] private TextMeshProUGUI text;

    private bool canEquipItem = false;

    
    void Update()
    {
    
    }

    public void WriteButton(bool canEquipItem)
    {
        if (canEquipItem)
            text.text = "EQUIP";
        else
            text.text = "BUY";
    }
    
    public void WriteInTextBuy()
    {
        canEquipItem = false;
        text.text = "BUY";
    }
    public void WriteInTextEquip()
    {
        canEquipItem = true;
        text.text = "EQUIP";
    }
    public void WriteInTextEquipped()
    {
        canEquipItem = false;
        text.text = "EQUIPPED";
    }
    public void SetCanEquipItem(bool aux)
    {
        this.canEquipItem = aux;
    }

    public bool GetCanEquipItem()
    {
        return this.canEquipItem;
    }
}
