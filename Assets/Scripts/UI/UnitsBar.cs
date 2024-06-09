using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class UnitsBar : MonoBehaviour
{

    [SerializeField] private TextMeshProUGUI nameText;
    [SerializeField] private Image avatar;

    [Header("Health Images")]
    [SerializeField] private Image healthBar;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void SetAvatar(Sprite newAvatar)
    {
        avatar.sprite = newAvatar;
    }

    private void SetNameText(string name)
    {
        this.nameText.text = name.ToString(); 
    }

    public void SetUpUnitUI(string name, Sprite newAvatar)
    {
        SetAvatar(newAvatar);
        SetNameText(name);
    }

    public void UpdateHealthBar(float newHealth)
    {
        this.healthBar.fillAmount = newHealth;
    }
}
