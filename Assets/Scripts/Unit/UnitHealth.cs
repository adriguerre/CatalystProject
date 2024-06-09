using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UnitHealth : MonoBehaviour
{

    [Header("Health Properties")]
    [SerializeField] private float health = 100f;
    [SerializeField] private float MAX_HEALTH = 100f;
    private UnitsBar unitsHealthUI;

    public bool isDead { get; private set; }
    [SerializeField] private SoldierAnimator animator;
    // Start is called before the first frame update
    void Start()
    {
       
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Damage(float amount)
    {
        health -= amount;
        if (health < 0)
        {
            health = 0;
            isDead = true;
            //Dead character
            //onSoldierDied?.Invoke(this, EventArgs.Empty);
            animator.OnSoldierDied(); 
            Collider _collider = GetComponentInChildren<Collider>();
            _collider.enabled = false; 
        }
        UpdateUI(); 
    }

    public void UpdateUI()
    {
        unitsHealthUI.UpdateHealthBar(health / MAX_HEALTH);
    }

    public void SetUnitHealthUI(UnitsBar unitsBar)
    {
        this.unitsHealthUI = unitsBar;
    }
}
