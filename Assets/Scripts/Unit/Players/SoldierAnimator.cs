using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoldierAnimator : MonoBehaviour
{

    [SerializeField] private SoldierLine movementAnimations;
    [SerializeField] private UnitHealth unitHealth;
    
    private Animator _animator;
    // Start is called before the first frame update
    void Start()
    {

        _animator = GetComponent<Animator>();
        
        movementAnimations.onStartedMoving += OnStartedMoving; 
        movementAnimations.onStoppedMoving += OnStoppedMoving;

   
    }

    public void OnSoldierDied()
    {
        int random = UnityEngine.Random.Range(0, 5);
        _animator.SetInteger("died", random);
    }

    private void OnStoppedMoving(object sender, EventArgs e)
    {
        _animator.SetBool("running", false);
    }

    private void OnStartedMoving(object sender, EventArgs e)
    {
        _animator.SetBool("running", true);
    }

  
}
